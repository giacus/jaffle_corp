#!/usr/bin/env python3
"""Verify the isolated dbt 2 semantic graph fixture and negative controls."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "test/fixtures/dbt2-semantic-graph"


def digest(items: list[Any]) -> str:
    return hashlib.sha256(json.dumps(sorted(items, key=lambda x: json.dumps(x, sort_keys=True)), separators=(",", ":"), sort_keys=True).encode()).hexdigest()


def resolve_dbt(value: Path | None) -> Path:
    candidate = value or (Path(os.environ["DBT2_EXECUTABLE"]) if os.environ.get("DBT2_EXECUTABLE") else None)
    if candidate is None or not candidate.is_file():
        raise SystemExit("pass --dbt or set DBT2_EXECUTABLE to the official dbt 2.0.6 executable")
    version = subprocess.run([str(candidate), "--version"], text=True, capture_output=True, check=False)
    text = version.stdout + version.stderr
    if version.returncode != 0 or not re.search(r"(?m)^\s*dbt 2\.0\.6\s*$", text):
        raise SystemExit(f"expected dbt 2.0.6, got {text[:500]!r}")
    return candidate.resolve()


def setup_profile(fixture: Path) -> Path:
    profile = fixture / "profiles"
    profile.mkdir(exist_ok=True)
    (profile / "profiles.yml").write_text(
        "jaffle_corp_dbt2_semantic_graph:\n  target: dev\n  outputs:\n    dev:\n      type: duckdb\n"
        f"      path: {fixture / 'semantic_graph.duckdb'}\n      threads: 1\n"
    )
    return profile


def invoke(dbt: Path, args: list[str], fixture: Path) -> tuple[int, str]:
    env = {**os.environ, "DBT_SEND_ANONYMOUS_USAGE_STATS": "false", "PYTHONDONTWRITEBYTECODE": "1"}
    completed = subprocess.run([str(dbt), *args], cwd=fixture, text=True, capture_output=True, env=env, check=False)
    return completed.returncode, (completed.stdout + completed.stderr)[-6000:]


def run_parse(dbt: Path, fixture: Path, case: str) -> tuple[int, dict[str, Any] | None, str, list[list[str]]]:
    profile = setup_profile(fixture)
    target = fixture / "target"
    commands = [["deps", "--project-dir", str(fixture)], ["parse", "--project-dir", str(fixture), "--profiles-dir", str(profile), "--target-path", str(target), "--no-partial-parse"]]
    logs: list[str] = []
    for command in commands:
        code, log = invoke(dbt, command, fixture)
        logs.append(log)
        if code:
            return code, None, log, commands
    manifest = target / "manifest.json"
    data = json.loads(manifest.read_text()) if manifest.exists() else None
    return 0, data, logs[-1], commands


def graph_sets(manifest: dict[str, Any]) -> dict[str, Any]:
    sections = ("nodes", "sources", "semantic_models", "metrics", "exposures", "saved_queries")
    resources = {key: sorted(manifest.get(key, {})) for key in sections}
    all_ids = sorted(item for values in resources.values() for item in values)
    direct = sorted((rid, dep) for key in sections for rid, resource in manifest.get(key, {}).items() for dep in resource.get("depends_on", {}).get("nodes", []))
    # dbt writes parent_map as child -> parents; normalize both maps to (consumer, dependency).
    parent = sorted((child_id, parent_id) for child_id, parents in manifest.get("parent_map", {}).items() for parent_id in parents)
    child = sorted((parent_id, child_id) for child_id, parents in manifest.get("child_map", {}).items() for parent_id in parents)
    return {
        "resources": resources, "allIds": all_ids,
        "edges": {"dependsOnNodes": direct, "parentMap": parent, "childMapNormalized": child},
        "edgeHashes": {name: digest(value) for name, value in (("dependsOnNodes", direct), ("parentMap", parent), ("childMapNormalized", child))},
        "edgeParity": direct == parent == child,
    }


def metric_views(manifest: dict[str, Any]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for metric_id, metric in sorted(manifest.get("metrics", {}).items()):
        params = metric.get("type_params", {})
        refs: list[str] = []
        for key in ("metrics", "input_metrics", "input_measures"):
            refs.extend(item.get("name") for item in (params.get(key) or []) if isinstance(item, dict) and item.get("name"))
        for outer, keys in (("cumulative_type_params", ("metric",)), ("conversion_type_params", ("base_metric", "conversion_metric"))):
            for key in keys:
                ref = (params.get(outer) or {}).get(key) or {}
                if ref.get("name"):
                    refs.append(ref["name"])
        for key in ("numerator", "denominator"):
            ref = params.get(key) or {}
            if ref.get("name"):
                refs.append(ref["name"])
        result[metric_id] = {"type": metric.get("type"), "directDependsOn": sorted(metric.get("depends_on", {}).get("nodes", [])), "nestedMetricRefs": sorted(set(refs))}
    return result


def dangling_dependencies(manifest: dict[str, Any]) -> dict[str, list[str]]:
    all_resource_ids = set(graph_sets(manifest)["allIds"])
    return {
        rid: sorted(set(resource.get("depends_on", {}).get("nodes", [])) - all_resource_ids)
        for section in ("nodes", "sources", "semantic_models", "metrics", "exposures", "saved_queries")
        for rid, resource in manifest.get(section, {}).items()
        if set(resource.get("depends_on", {}).get("nodes", [])) - all_resource_ids
    }


def assert_manifest(manifest: dict[str, Any]) -> dict[str, Any]:
    source_id = "source.legacy.settlement_gateway.settlement_events"
    model_id = "model.jaffle_corp_dbt2_semantic_graph.settlement_events"
    semantic_id = "semantic_model.jaffle_corp_dbt2_semantic_graph.settlement_events"
    expected = {"settlement_event_count": "simple", "settled_amount_total": "simple", "gross_amount_total": "simple", "settlement_rate": "ratio", "unsettled_amount_total": "derived", "cumulative_settled_amount": "cumulative", "seven_day_settlement_rate": "conversion"}
    assert source_id in manifest.get("sources", {}), source_id
    assert model_id in manifest.get("nodes", {}), model_id
    assert semantic_id in manifest.get("semantic_models", {}), semantic_id
    assert source_id in manifest["nodes"][model_id]["depends_on"]["nodes"]
    assert model_id in manifest["semantic_models"][semantic_id]["depends_on"]["nodes"]
    for name, kind in expected.items():
        metric_id = f"metric.jaffle_corp_dbt2_semantic_graph.{name}"
        metric = manifest.get("metrics", {}).get(metric_id)
        assert metric and metric["type"] == kind, metric_id
        if kind == "simple":
            assert metric["depends_on"]["nodes"] == [semantic_id], metric_id
        else:
            assert all(dep.startswith("metric.") for dep in metric["depends_on"]["nodes"]), metric_id
    views = metric_views(manifest)
    assert views["metric.jaffle_corp_dbt2_semantic_graph.settlement_rate"]["nestedMetricRefs"] == ["gross_amount_total", "settled_amount_total"]
    assert views["metric.jaffle_corp_dbt2_semantic_graph.unsettled_amount_total"]["nestedMetricRefs"] == ["gross_amount_total", "settled_amount_total"]
    assert views["metric.jaffle_corp_dbt2_semantic_graph.cumulative_settled_amount"]["nestedMetricRefs"] == ["settled_amount_total"]
    assert views["metric.jaffle_corp_dbt2_semantic_graph.seven_day_settlement_rate"]["nestedMetricRefs"] == ["settled_amount_total", "settlement_event_count"]
    graph = graph_sets(manifest)
    expected_resources = {
        "nodes": [model_id],
        "sources": [source_id],
        "semantic_models": [semantic_id],
        "metrics": sorted(f"metric.jaffle_corp_dbt2_semantic_graph.{name}" for name in expected),
        "exposures": [],
        "saved_queries": [],
    }
    assert graph["resources"] == expected_resources, graph["resources"]
    expected_edges = sorted([
        (model_id, source_id),
        (semantic_id, model_id),
        *[(f"metric.jaffle_corp_dbt2_semantic_graph.{name}", semantic_id) for name in ("settlement_event_count", "settled_amount_total", "gross_amount_total")],
        (f"metric.jaffle_corp_dbt2_semantic_graph.settlement_rate", f"metric.jaffle_corp_dbt2_semantic_graph.settled_amount_total"),
        (f"metric.jaffle_corp_dbt2_semantic_graph.settlement_rate", f"metric.jaffle_corp_dbt2_semantic_graph.gross_amount_total"),
        (f"metric.jaffle_corp_dbt2_semantic_graph.unsettled_amount_total", f"metric.jaffle_corp_dbt2_semantic_graph.gross_amount_total"),
        (f"metric.jaffle_corp_dbt2_semantic_graph.unsettled_amount_total", f"metric.jaffle_corp_dbt2_semantic_graph.settled_amount_total"),
        (f"metric.jaffle_corp_dbt2_semantic_graph.cumulative_settled_amount", f"metric.jaffle_corp_dbt2_semantic_graph.settled_amount_total"),
        (f"metric.jaffle_corp_dbt2_semantic_graph.seven_day_settlement_rate", f"metric.jaffle_corp_dbt2_semantic_graph.settlement_event_count"),
        (f"metric.jaffle_corp_dbt2_semantic_graph.seven_day_settlement_rate", f"metric.jaffle_corp_dbt2_semantic_graph.settled_amount_total"),
    ])
    assert graph["edges"]["dependsOnNodes"] == expected_edges, graph["edges"]
    assert graph["edgeParity"], graph["edges"]
    return {"graph": graph, "metricViews": views, "expectedMetricTypes": expected}


def copy_baseline(source: Path, destination: Path, report: dict[str, Any], dbt: Path) -> None:
    if destination.exists() or destination.is_symlink():
        raise SystemExit(f"--keep-baseline destination already exists: {destination}")
    destination = destination.resolve()
    temp_root = Path(tempfile.gettempdir()).resolve()
    if destination == ROOT or ROOT in destination.parents or temp_root not in destination.parents:
        raise SystemExit("--keep-baseline must be a new path below the operating system temporary directory and outside the repository")
    shutil.copytree(source, destination)
    (destination / "provenance.json").write_text(json.dumps({"dbt": str(dbt), "dbtVersion": "2.0.6", "fixture": "test/fixtures/dbt2-semantic-graph", "verification": report, "commands": ["dbt deps", "dbt parse --no-partial-parse"]}, indent=2) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dbt", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--keep-baseline", type=Path)
    args = parser.parse_args()
    dbt = resolve_dbt(args.dbt)
    with tempfile.TemporaryDirectory(prefix="dbt2-semantic-graph-") as temp:
        root = Path(temp)
        cases: dict[str, Any] = {}
        valid = root / "valid"
        shutil.copytree(FIXTURE, valid)
        code, manifest, logs, commands = run_parse(dbt, valid, "valid")
        assert code == 0 and manifest, logs
        valid_report = assert_manifest(manifest)
        cases["valid"] = {"exit": code, **valid_report, "commands": commands, "manifestResourceCounts": {k: len(v) for k, v in valid_report["graph"]["resources"].items()}}
        if args.keep_baseline:
            copy_baseline(valid, args.keep_baseline, cases["valid"], dbt)
        for name, replacements in {"unknown-source-package": [("legacy.settlement_gateway", "unknown.settlement_gateway")], "missing-source-table": [("settlement_events')", "missing_events')")],}.items():
            case = root / name; shutil.copytree(FIXTURE, case)
            sql = case / "models/settlement_events.sql"; text = sql.read_text()
            for old, new in replacements: text = text.replace(old, new)
            sql.write_text(text)
            code, manifest, logs, _ = run_parse(dbt, case, name)
            assert code != 0, (name, logs)
            cases[name] = {"exit": code, "manifestProduced": manifest is not None, "diagnosticsTail": logs}
        disabled = root / "disabled-semantic-model"; shutil.copytree(FIXTURE, disabled)
        yml = disabled / "models/settlement_events.yml"; yml.write_text(yml.read_text().replace("enabled: true", "enabled: false", 1))
        code, manifest, logs, _ = run_parse(dbt, disabled, "disabled-semantic-model")
        assert code == 0 and manifest, logs
        dangling = dangling_dependencies(manifest)
        cases["disabled-semantic-model"] = {"exit": code, "semanticModels": sorted(manifest.get("semantic_models", {})), "metrics": sorted(manifest.get("metrics", {})), "danglingMetricDependencies": dangling}
        omitted_enabled = root / "omitted-semantic-enabled"; shutil.copytree(FIXTURE, omitted_enabled)
        yml = omitted_enabled / "models/settlement_events.yml"; yml.write_text(yml.read_text().replace("      enabled: true\n", "", 1))
        code, manifest, logs, _ = run_parse(dbt, omitted_enabled, "omitted-semantic-enabled")
        assert code != 0, logs
        cases["omitted-semantic-enabled"] = {"exit": code, "manifestProduced": manifest is not None, "semanticModels": sorted(manifest.get("semantic_models", {})) if manifest else [], "diagnosticsTail": logs}
        omitted_name = root / "omitted-semantic-name"; shutil.copytree(FIXTURE, omitted_name)
        yml = omitted_name / "models/settlement_events.yml"; yml.write_text(yml.read_text().replace("      name: settlement_events\n", "", 1))
        code, manifest, logs, _ = run_parse(dbt, omitted_name, "omitted-semantic-name")
        assert code == 0 and manifest and "semantic_model.jaffle_corp_dbt2_semantic_graph.settlement_events" in manifest.get("semantic_models", {}), logs
        cases["omitted-semantic-name"] = {"exit": code, "manifestProduced": manifest is not None, "semanticModels": sorted(manifest.get("semantic_models", {})) if manifest else [], "semanticModelNames": sorted(v.get("name") for v in manifest.get("semantic_models", {}).values()) if manifest else [], "diagnosticsTail": logs}
        disabled_model = root / "disabled-model"; shutil.copytree(FIXTURE, disabled_model)
        yml = disabled_model / "models/settlement_events.yml"; yml.write_text(yml.read_text().replace("    semantic_model:\n", "    config:\n      enabled: false\n    semantic_model:\n", 1))
        code, manifest, logs, _ = run_parse(dbt, disabled_model, "disabled-model")
        assert code != 0, logs
        cases["disabled-model"] = {"exit": code, "manifestProduced": manifest is not None, "diagnosticsTail": logs}
        disabled_metric = root / "disabled-metric"; shutil.copytree(FIXTURE, disabled_metric)
        yml = disabled_metric / "models/settlement_events.yml"; yml.write_text(yml.read_text().replace("        config:\n          enabled: true\n", "        config:\n          enabled: false\n", 1))
        code, manifest, logs, _ = run_parse(dbt, disabled_metric, "disabled-metric")
        assert code == 0 and manifest, logs
        disabled_id = "metric.jaffle_corp_dbt2_semantic_graph.settlement_event_count"
        assert disabled_id not in manifest.get("metrics", {})
        cases["disabled-metric"] = {"exit": code, "metricPresent": disabled_id in manifest.get("metrics", {}), "metrics": sorted(manifest.get("metrics", {}))}
        collision = root / "duplicate-dotted-source"; shutil.copytree(FIXTURE, collision)
        (collision / "models/sources.yml").write_text("version: 2\nsources:\n  - name: legacy.settlement_gateway\n    schema: raw\n    tables:\n      - name: settlement_events\n")
        code, manifest, logs, _ = run_parse(dbt, collision, "duplicate-dotted-source")
        source_ids = sorted(manifest.get("sources", {})) if manifest else []
        model_deps = sorted(manifest.get("nodes", {}).get("model.jaffle_corp_dbt2_semantic_graph.settlement_events", {}).get("depends_on", {}).get("nodes", [])) if manifest else []
        expected_source = "source.legacy.settlement_gateway.settlement_events"
        local_collision_source = "source.jaffle_corp_dbt2_semantic_graph.legacy.settlement_gateway.settlement_events"
        model_id = "model.jaffle_corp_dbt2_semantic_graph.settlement_events"
        assert code == 0 and source_ids == sorted([expected_source, local_collision_source]), (code, source_ids, logs)
        assert model_deps == [local_collision_source], model_deps
        cases["duplicate-dotted-source"] = {"exit": code, "sourceIds": source_ids, "modelDependsOn": model_deps, "selectedSource": local_collision_source, "packageSource": expected_source, "diagnosticsTail": logs}
        disabled_collision = root / "disabled-local-dotted-source"; shutil.copytree(FIXTURE, disabled_collision)
        (disabled_collision / "models/sources.yml").write_text("version: 2\nsources:\n  - name: legacy.settlement_gateway\n    config:\n      enabled: false\n    schema: raw\n    tables:\n      - name: settlement_events\n")
        code, manifest, logs, _ = run_parse(dbt, disabled_collision, "disabled-local-dotted-source")
        source_ids = sorted(manifest.get("sources", {})) if manifest else []
        model_deps = sorted(manifest.get("nodes", {}).get(model_id, {}).get("depends_on", {}).get("nodes", [])) if manifest else []
        assert code == 0 and source_ids == [expected_source], (code, source_ids, logs)
        assert model_deps == [expected_source], model_deps
        cases["disabled-local-dotted-source"] = {"exit": code, "sourceIds": source_ids, "modelDependsOn": model_deps, "selectedSource": expected_source, "disabledLocalSource": local_collision_source, "diagnosticsTail": logs}
    report = {"schemaVersion": 2, "kind": "dbt2-semantic-graph-fixture-verification", "dbt": str(dbt), "fixture": "test/fixtures/dbt2-semantic-graph", "cases": cases}
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True); args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
