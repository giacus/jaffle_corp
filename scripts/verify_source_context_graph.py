#!/usr/bin/env python3
"""Check order-audit block variables and scalar tags in isolated dbt copies."""
from __future__ import annotations
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "test/fixtures/source-context-graph"


def source_digest() -> str:
    rows = [(str(p.relative_to(FIXTURE)), hashlib.sha256(p.read_bytes()).hexdigest())
            for p in sorted(FIXTURE.rglob("*")) if p.is_file()]
    return hashlib.sha256(json.dumps(rows, separators=(",", ":")).encode()).hexdigest()


def verify(dbt: Path, output: Path) -> None:
    before = source_digest()
    version = subprocess.run([str(dbt), "--version"], text=True, capture_output=True, check=True, timeout=30)
    report = {"schemaVersion": 1, "nativeExecutable": str(dbt), "nativeVersionOutput": version.stdout + version.stderr,
              "fixtureSha256": before, "cases": []}
    passed = True
    try:
        for override in (None, "expedited_orders"):
            with tempfile.TemporaryDirectory(prefix="jaffle-source-context-") as directory:
                scratch = Path(directory)
                project = scratch / "project"
                shutil.copytree(FIXTURE, project)
                profiles = scratch / "profiles"
                profiles.mkdir()
                shutil.copyfile(project / "profiles.example.yml", profiles / "profiles.yml")
                args = [str(dbt), "parse", "--project-dir", str(project), "--profiles-dir", str(profiles),
                        "--target-path", str(scratch / "target"), "--log-path", str(scratch / "logs"),
                        "--no-partial-parse", "--vars", json.dumps({"orders_relation_override": override})]
                env = {**os.environ, "HOME": str(scratch), "DBT_SEND_ANONYMOUS_USAGE_STATS": "false",
                       "PYTHONDONTWRITEBYTECODE": "1"}
                result = subprocess.run(args, cwd=project, env=env, capture_output=True, text=True, check=False, timeout=120)
                case = {"override": override, "command": args, "exitCode": result.returncode,
                        "stdout": result.stdout, "stderr": result.stderr, "exact": False}
                manifest_path = scratch / "target/manifest.json"
                if manifest_path.exists():
                    data = manifest_path.read_bytes()
                    manifest = json.loads(data)
                    nodes = manifest.get("nodes", {})
                    audit = nodes["model.jaffle_source_context.order_audit"]
                    source = manifest["sources"]["source.jaffle_source_context.checkout.orders"]
                    expected = ["model.jaffle_source_context." + (override or "stg_orders")]
                    case.update({"dbtVersion": manifest["metadata"]["dbt_version"],
                                 "manifestSha256": hashlib.sha256(data).hexdigest(),
                                 "auditDependencies": audit["depends_on"]["nodes"],
                                 "auditTags": audit["tags"], "sourceTags": source["tags"],
                                 "macroPresent": "macro.jaffle_source_context.audit_orders_relation" in manifest.get("macros", {}),
                                 "docPresent": "doc.jaffle_source_context.audit_order_source" in manifest.get("docs", {})})
                    case["exact"] = (result.returncode == 0 and sorted(audit["depends_on"]["nodes"]) == expected
                                     and audit["tags"] == ["order_audit"]
                                     and set(source["tags"]) == {"landed", "orders"}
                                     and case["macroPresent"] and case["docPresent"])
                report["cases"].append(case)
                passed = passed and case["exact"]
    finally:
        report["fixtureUnchanged"] = before == source_digest()
        report["exact"] = passed and report["fixtureUnchanged"] and len(report["cases"]) == 2
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(report, indent=2) + "\n")
    if not report["exact"]:
        raise SystemExit(f"Native source-context control failed; inspect {output}")
    print(f"Both source-selection cases passed; source fixture unchanged. {output}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dbt", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()
    verify(args.dbt.resolve(strict=True), args.out.resolve())
