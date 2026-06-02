#!/usr/bin/env python3
"""Execute every semantic input spec against the local dbt/DuckDB project."""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any

import duckdb
import yaml


ROOT = Path(__file__).resolve().parents[1]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--project",
        action="append",
        help="Project directory or project name to run. Defaults to all projects with semantic_inputs.",
    )
    parser.add_argument("--profiles-dir", default=str(ROOT), help="Directory containing profiles.yml.")
    parser.add_argument("--duckdb-path", default=str(ROOT / "jaffle_corp.duckdb"))
    parser.add_argument("--limit", type=int, default=20)
    return parser.parse_args()


def load_yaml(path: Path) -> dict[str, Any]:
    with path.open() as handle:
        return yaml.safe_load(handle) or {}


def project_dirs(selected: list[str] | None) -> list[Path]:
    candidates = sorted(path.parent.parent for path in ROOT.glob("projects/*/semantic_inputs/*.yml"))
    projects = sorted(set(candidates))
    if not selected:
        return projects

    wanted = set()
    for item in selected:
        path = Path(item)
        wanted.add(path.name if path.name else item)
    return [project for project in projects if project.name in wanted or str(project) in wanted]


def manifest_path(project: Path) -> Path:
    path = project / "target" / "manifest.json"
    if not path.exists():
        raise RuntimeError(
            f"{project}/target/manifest.json is missing. Run dbt build for this project before "
            "executing semantic inputs."
        )
    return path


def load_manifest(project: Path) -> dict[str, Any]:
    with manifest_path(project).open() as handle:
        return json.load(handle)


def model_relation(manifest: dict[str, Any], model_name: str) -> str:
    matches = [
        node
        for node in manifest["nodes"].values()
        if node.get("resource_type") == "model" and node.get("name") == model_name
    ]
    if not matches:
        raise RuntimeError(f"Could not find model {model_name!r} in manifest.")
    return matches[0]["relation_name"]


def quote_identifier(value: str) -> str:
    return '"' + value.replace('"', '""') + '"'


def relation_columns(connection: duckdb.DuckDBPyConnection, relation: str) -> set[str]:
    cursor = connection.execute(f"select * from {relation} limit 0")
    return {column[0] for column in cursor.description}


def column_owner(column: str, columns_by_alias: dict[str, set[str]]) -> str | None:
    for alias, columns in columns_by_alias.items():
        if column in columns:
            return alias
    return None


def column_expr(alias: str, column: str) -> str:
    return f"{quote_identifier(alias)}.{quote_identifier(column)}"


def join_conditions(
    spec: dict[str, Any],
    base_alias: str,
    input_alias: str,
    base_columns: set[str],
    input_columns: set[str],
    input_spec: dict[str, Any],
    base_time_column: str | None,
) -> list[str]:
    if input_spec.get("join_key"):
        key = input_spec["join_key"]
        if key not in base_columns or key not in input_columns:
            raise RuntimeError(f"join_key {key!r} is not present in both joined inputs.")
        return [f"{column_expr(base_alias, key)} = {column_expr(input_alias, key)}"]

    conditions = []
    input_time_column = input_spec.get("time_column")
    if base_time_column and input_time_column:
        conditions.append(
            f"cast({column_expr(base_alias, base_time_column)} as date) = "
            f"cast({column_expr(input_alias, input_time_column)} as date)"
        )

    for dimension in spec.get("dimensions", []):
        if dimension in base_columns and dimension in input_columns:
            conditions.append(f"{column_expr(base_alias, dimension)} = {column_expr(input_alias, dimension)}")

    if not conditions:
        raise RuntimeError(
            f"Input {input_spec.get('ref')!r} needs join_key or common time/dimension columns."
        )
    return conditions


def run_lightweight_spec(
    duckdb_path: Path,
    manifest: dict[str, Any],
    spec_path: Path,
    spec: dict[str, Any],
    limit: int,
) -> None:
    inputs = spec.get("inputs") or []
    if not inputs:
        raise RuntimeError(f"{spec_path} has no inputs.")

    connection = duckdb.connect(str(duckdb_path), read_only=True)
    try:
        aliases = [f"i{index}" for index in range(len(inputs))]
        relations = [model_relation(manifest, input_spec["ref"]) for input_spec in inputs]
        columns_by_alias = {
            alias: relation_columns(connection, relation) for alias, relation in zip(aliases, relations)
        }

        base_alias = aliases[0]
        base_time_column = inputs[0].get("time_column")
        from_clause = f"{relations[0]} as {quote_identifier(base_alias)}"
        for alias, relation, input_spec in zip(aliases[1:], relations[1:], inputs[1:]):
            conditions = join_conditions(
                spec,
                base_alias,
                alias,
                columns_by_alias[base_alias],
                columns_by_alias[alias],
                input_spec,
                base_time_column,
            )
            from_clause += (
                f"\nleft join {relation} as {quote_identifier(alias)}"
                f"\n    on {' and '.join(conditions)}"
            )

        select_exprs: list[str] = []
        group_exprs: list[str] = []
        if base_time_column:
            expr = f"cast({column_expr(base_alias, base_time_column)} as date)"
            select_exprs.append(f"{expr} as metric_time")
            group_exprs.append(expr)

        for dimension in spec.get("dimensions", []):
            alias = column_owner(dimension, columns_by_alias)
            if alias is None:
                raise RuntimeError(f"{spec_path}: dimension {dimension!r} does not exist on any input.")
            expr = column_expr(alias, dimension)
            select_exprs.append(f"{expr} as {quote_identifier(dimension)}")
            group_exprs.append(expr)

        for measure in spec.get("measures", []):
            alias = column_owner(measure, columns_by_alias)
            if alias is None:
                if measure.endswith("_count"):
                    select_exprs.append(f"count(*) as {quote_identifier(measure)}")
                    continue
                raise RuntimeError(f"{spec_path}: measure {measure!r} does not exist on any input.")
            select_exprs.append(f"sum({column_expr(alias, measure)}) as {quote_identifier(measure)}")

        group_by = f"\ngroup by {', '.join(str(index) for index in range(1, len(group_exprs) + 1))}" if group_exprs else ""
        select_sql = ",\n    ".join(select_exprs)
        sql = f"select\n    {select_sql}\nfrom {from_clause}{group_by}\nlimit {limit}"
        rows = connection.execute(sql).fetchall()
    finally:
        connection.close()
    print(f"OK {spec_path.relative_to(ROOT)} ({len(rows)} rows)")


def run_metricflow_validate(project: Path, profiles_dir: Path, duckdb_path: Path) -> None:
    env = os.environ.copy()
    env["DBT_PROFILES_DIR"] = str(profiles_dir)
    env["JAFFLE_CORP_DUCKDB_PATH"] = str(duckdb_path)
    subprocess.run(
        ["mf", "validate-configs", "--skip-dw"],
        cwd=project,
        env=env,
        check=True,
    )


def run_metricflow_spec(
    project: Path,
    profiles_dir: Path,
    duckdb_path: Path,
    spec_path: Path,
    spec: dict[str, Any],
    limit: int,
) -> None:
    env = os.environ.copy()
    env["DBT_PROFILES_DIR"] = str(profiles_dir)
    env["JAFFLE_CORP_DUCKDB_PATH"] = str(duckdb_path)
    group_by = ["metric_time", *spec.get("dimensions", [])]
    command = [
        "mf",
        "query",
        "--metrics",
        ",".join(spec["metrics"]),
        "--group-by",
        ",".join(group_by),
        "--limit",
        str(limit),
        "--quiet",
    ]
    subprocess.run(command, cwd=project, env=env, check=True)
    print(f"OK {spec_path.relative_to(ROOT)}")


def main() -> int:
    args = parse_args()
    profiles_dir = Path(args.profiles_dir).resolve()
    duckdb_path = Path(args.duckdb_path).resolve()
    projects = project_dirs(args.project)
    if not projects:
        print("No semantic input projects matched.", file=sys.stderr)
        return 1

    failures = 0

    for project in projects:
        specs = sorted((project / "semantic_inputs").glob("*.yml"))
        if not specs:
            continue

        try:
            manifest = load_manifest(project)
        except Exception as exc:
            print(f"ERROR {project.relative_to(ROOT)}: {exc}", file=sys.stderr)
            failures += 1
            continue

        metricflow_specs = [path for path in specs if "metrics" in load_yaml(path)]
        if metricflow_specs:
            try:
                run_metricflow_validate(project, profiles_dir, duckdb_path)
            except Exception as exc:
                print(f"ERROR {project.relative_to(ROOT)} MetricFlow validation failed: {exc}", file=sys.stderr)
                failures += 1
                continue

        for spec_path in specs:
            spec = load_yaml(spec_path)
            try:
                if "metrics" in spec:
                    run_metricflow_spec(project, profiles_dir, duckdb_path, spec_path, spec, args.limit)
                else:
                    run_lightweight_spec(duckdb_path, manifest, spec_path, spec, args.limit)
            except Exception as exc:
                print(f"ERROR {spec_path.relative_to(ROOT)}: {exc}", file=sys.stderr)
                failures += 1

    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
