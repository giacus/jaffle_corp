#!/usr/bin/env python3
"""Report public dbt model contract changes between a Git ref and the worktree."""

from __future__ import annotations

import argparse
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import yaml


ROOT = Path(__file__).resolve().parents[1]


@dataclass(frozen=True)
class PublicContract:
    enforced: bool
    columns: dict[str, str]


def git(root: Path, *args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=root, text=True).strip()


def yaml_paths_at_ref(root: Path, ref: str) -> list[str]:
    output = git(root, "ls-tree", "-r", "--name-only", ref, "--", "projects")
    return [
        path
        for path in output.splitlines()
        if "/models/" in path and Path(path).suffix in {".yml", ".yaml"}
    ]


def worktree_yaml(root: Path) -> Iterable[tuple[str, str]]:
    for path in sorted((root / "projects").glob("*/models/**/*")):
        if path.suffix in {".yml", ".yaml"}:
            yield str(path.relative_to(root)), path.read_text(encoding="utf-8")


def ref_yaml(root: Path, ref: str) -> Iterable[tuple[str, str]]:
    for path in yaml_paths_at_ref(root, ref):
        yield path, git(root, "show", f"{ref}:{path}")


def merged_config(base: dict, override: dict | None = None) -> dict:
    result = dict(base or {})
    for key, value in (override or {}).items():
        if key == "contract" and isinstance(value, dict):
            result[key] = {**result.get(key, {}), **value}
        else:
            result[key] = value
    return result


def public_contracts(documents: Iterable[tuple[str, str]]) -> dict[str, PublicContract]:
    contracts: dict[str, PublicContract] = {}
    for path, text in documents:
        parts = Path(path).parts
        if len(parts) < 2:
            continue
        package = parts[1]
        document = yaml.safe_load(text) or {}
        for model in document.get("models", []) or []:
            if not isinstance(model, dict) or not isinstance(model.get("name"), str):
                continue
            base_config = merged_config(model.get("config", {}))
            versions = model.get("versions", []) or []
            variants = versions if versions else [None]
            for version in variants:
                version = version if isinstance(version, dict) else {}
                config = merged_config(base_config, version.get("config", {}))
                access = config.get("access", model.get("access"))
                if access != "public":
                    continue
                columns = version.get("columns") or model.get("columns") or []
                column_types = {
                    column["name"]: str(column.get("data_type", "<unspecified>"))
                    for column in columns
                    if isinstance(column, dict) and isinstance(column.get("name"), str)
                }
                version_suffix = f".v{version['v']}" if "v" in version else ""
                key = f"{package}.{model['name']}{version_suffix}"
                contracts[key] = PublicContract(
                    enforced=bool(config.get("contract", {}).get("enforced")),
                    columns=column_types,
                )
    return contracts


def changes(
    before: dict[str, PublicContract], after: dict[str, PublicContract]
) -> list[str]:
    lines: list[str] = []
    for name in sorted(before.keys() - after.keys()):
        lines.append(f"{name}: removed public model")
    for name in sorted(after.keys() - before.keys()):
        lines.append(f"{name}: added public model")
    for name in sorted(before.keys() & after.keys()):
        old = before[name]
        new = after[name]
        if old.enforced != new.enforced:
            lines.append(
                f"{name}: contract enforcement changed from "
                f"`{str(old.enforced).lower()}` to `{str(new.enforced).lower()}`"
            )
        for column in sorted(old.columns.keys() - new.columns.keys()):
            lines.append(f"{name}: removed column `{column}`")
        for column in sorted(new.columns.keys() - old.columns.keys()):
            lines.append(f"{name}: added column `{column}`")
        for column in sorted(old.columns.keys() & new.columns.keys()):
            if old.columns[column] != new.columns[column]:
                lines.append(
                    f"{name}: changed `{column}` from `{old.columns[column]}` "
                    f"to `{new.columns[column]}`"
                )
    return lines


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("base_ref")
    parser.add_argument("--root", type=Path, default=ROOT)
    args = parser.parse_args()
    root = args.root.resolve()

    before = public_contracts(ref_yaml(root, args.base_ref))
    after = public_contracts(worktree_yaml(root))
    report = changes(before, after)

    print("## Public contract changes")
    if report:
        print("\n".join(f"- {line}" for line in report))
    else:
        print("- No public contract changes.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
