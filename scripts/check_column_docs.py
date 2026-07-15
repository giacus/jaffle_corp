#!/usr/bin/env python3
"""Enforce complete, typed, lineage-aware model column documentation."""

from __future__ import annotations

import json
import os
import re
import sys
from collections import defaultdict
from functools import lru_cache
from pathlib import Path

import duckdb
import sqlglot
import yaml
from sqlglot import exp
from sqlglot.lineage import lineage


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "target" / "manifest.json"
DOC_REF = re.compile(r"^\{\{\s*doc\(['\"]([^'\"]+)['\"]\)\s*\}\}$")
DOC_BLOCK = re.compile(
    r"\{%\s*docs\s+([A-Za-z0-9_]+)\s*%\}(.*?)\{%\s*enddocs\s*%\}",
    re.DOTALL,
)


def is_staging(node: dict) -> bool:
    return node["package_name"] == "jaffle_shared" and "/staging/" in node["original_file_path"]


def project_doc_namespace(package_name: str) -> str:
    """Use the concise project name; `jaffle_` is constant across this repository."""
    return package_name.removeprefix("jaffle_")


def local_doc_id(node: dict, column: str) -> str:
    project = project_doc_namespace(node["package_name"])
    return f"{project}__{node['name']}__{column}"


def staging_doc_id(node: dict, column: str) -> str:
    return local_doc_id(node, column)


def main() -> int:
    if not MANIFEST_PATH.exists():
        print("Missing target/manifest.json; run scripts/generate_manifest.sh first.", file=sys.stderr)
        return 2

    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    models = {
        unique_id: node
        for unique_id, node in manifest["nodes"].items()
        if node.get("resource_type") == "model"
        and node.get("package_name") != "dbt_utils"
        and node.get("compiled_code")
    }
    by_relation = {
        (node.get("schema", "").lower(), node.get("alias", node["name"]).lower()): unique_id
        for unique_id, node in models.items()
    }
    ids_by_model_name: dict[str, list[str]] = defaultdict(list)
    for unique_id, node in models.items():
        ids_by_model_name[node["name"].lower()].append(unique_id)

    package_folders: dict[str, str] = {}
    metadata: dict[tuple[str, str, str], tuple[str | None, str | None]] = {}
    duplicate_metadata: list[str] = []
    for project_file in sorted((ROOT / "projects").glob("*/dbt_project.yml")):
        project = yaml.safe_load(project_file.read_text(encoding="utf-8"))
        package = project["name"]
        package_folders[package] = project_file.parent.name
        for yaml_file in sorted((project_file.parent / "models").rglob("*.yml")):
            parsed = yaml.safe_load(yaml_file.read_text(encoding="utf-8")) or {}
            for model in parsed.get("models", []) or []:
                for column in model.get("columns", []) or []:
                    key = (package, model["name"], column["name"])
                    if key in metadata:
                        duplicate_metadata.append(".".join(key))
                    metadata[key] = (column.get("description"), column.get("data_type"))

    definitions: dict[str, tuple[Path, str]] = {}
    duplicate_docs: list[str] = []
    for markdown in sorted((ROOT / "projects").glob("*/models/**/*.md")):
        text = markdown.read_text(encoding="utf-8")
        for name, body in DOC_BLOCK.findall(text):
            if name in definitions:
                duplicate_docs.append(name)
            definitions[name] = (markdown, body.strip())

    def source_model(lineage_node):
        """Resolve the single physical model represented by a lineage node's source."""
        tables = list(lineage_node.source.find_all(exp.Table))
        if isinstance(lineage_node.source, exp.Table):
            tables.insert(0, lineage_node.source)
        matches = {
            by_relation.get((table.db.lower(), table.name.lower()))
            for table in tables
        }
        matches.discard(None)
        return next(iter(matches)) if len(matches) == 1 else None

    def referenced_model(column: exp.Column):
        """Resolve a physical or dbt-injected CTE qualifier to a model."""
        table = column.table.lower()
        if not table:
            return None
        name = table.removeprefix("__dbt__cte__")
        matches = ids_by_model_name.get(name, [])
        return matches[0] if len(matches) == 1 else None

    def passthrough_origin(lineage_node, requested_column: str):
        """Trace aliases/stars that preserve both the name and value of a column."""
        expression = lineage_node.expression
        if isinstance(expression, exp.Alias):
            if not isinstance(expression.this, exp.Column):
                return None
            if expression.alias.lower() != expression.this.name.lower():
                return None
            upstream_id = referenced_model(expression.this)
            if upstream_id:
                return upstream_id, expression.this.name
            if len(lineage_node.downstream) != 1:
                return None
            return passthrough_origin(lineage_node.downstream[0], expression.this.name)
        if isinstance(expression, exp.Column):
            if expression.name.lower() != requested_column.lower():
                return None
            upstream_id = referenced_model(expression)
            if upstream_id:
                return upstream_id, expression.name
            if len(lineage_node.downstream) == 1:
                return passthrough_origin(lineage_node.downstream[0], expression.name)
            upstream_id = source_model(lineage_node)
            return (upstream_id, expression.name) if upstream_id else None
        if isinstance(expression, exp.Star):
            column = (
                lineage_node.name.rsplit(".", 1)[-1]
                if lineage_node.name != "*"
                else requested_column
            )
            upstream_id = source_model(lineage_node)
            return (upstream_id, column) if upstream_id else None
        if isinstance(expression, exp.Table):
            upstream_id = source_model(lineage_node)
            return (upstream_id, requested_column) if upstream_id else None
        if isinstance(expression, exp.Select) and all(
            isinstance(item, exp.Star) for item in expression.expressions
        ):
            upstream_id = source_model(lineage_node)
            return (upstream_id, requested_column) if upstream_id else None
        return None

    @lru_cache(maxsize=None)
    def owner(unique_id: str, column: str) -> tuple[str, str]:
        node = models[unique_id]
        if is_staging(node):
            return unique_id, column
        try:
            root = lineage(column, node["compiled_code"], dialect="duckdb")
        except Exception:
            return unique_id, column
        origin = passthrough_origin(root, column)
        if origin is None:
            return unique_id, column
        upstream_id, upstream_column = origin
        if upstream_id == unique_id:
            return unique_id, column
        return owner(upstream_id, upstream_column)

    def expected_doc(unique_id: str, column: str) -> tuple[str, str, str]:
        owner_id, owner_column = owner(unique_id, column)
        owner_node = models[owner_id]
        if is_staging(owner_node):
            return staging_doc_id(owner_node, owner_column), owner_id, owner_column
        return local_doc_id(owner_node, owner_column), owner_id, owner_column

    errors: list[str] = []
    errors.extend(f"duplicate docs block: {name}" for name in sorted(set(duplicate_docs)))
    errors.extend(
        f"duplicate model column declaration: {name}"
        for name in sorted(set(duplicate_metadata))
    )

    database_path = Path(
        os.environ.get("JAFFLE_CORP_DUCKDB_PATH", ROOT / "jaffle_corp.duckdb")
    )
    if not database_path.exists():
        print(
            f"Missing {database_path}; run scripts/validate_repo.sh to build model relations first.",
            file=sys.stderr,
        )
        return 2
    connection = duckdb.connect(str(database_path), read_only=True)
    actual_columns: dict[str, list[tuple[str, str]]] = {}
    for unique_id, node in sorted(models.items()):
        try:
            rows = connection.execute(f"describe {node['compiled_code']}").fetchall()
        except Exception as exc:
            errors.append(f"{node['name']}: could not inspect compiled output: {exc}")
            continue
        actual_columns[unique_id] = [
            (str(row[0]), str(row[1]).lower()) for row in rows
        ]

    expected_definitions: dict[str, tuple[str, str]] = {}
    model_assignments = 0
    reused_assignments = 0

    for unique_id, node in sorted(models.items()):
        outputs = actual_columns.get(unique_id, [])
        output_names = [column for column, _ in outputs]
        declared_names = [
            column
            for package, model, column in metadata
            if package == node["package_name"] and model == node["name"]
        ]
        missing = sorted(set(output_names) - set(declared_names))
        extra = sorted(set(declared_names) - set(output_names))
        if missing:
            errors.append(f"{node['name']}: missing YAML columns: {', '.join(missing)}")
        if extra:
            errors.append(f"{node['name']}: YAML columns not in model output: {', '.join(extra)}")

        for column, actual_type in outputs:
            model_assignments += 1
            doc_name, owner_id, owner_column = expected_doc(unique_id, column)
            key = (node["package_name"], node["name"], column)
            actual_description, declared_type = metadata.get(key, (None, None))
            expected_description = f"{{{{ doc('{doc_name}') }}}}"
            if actual_description != expected_description:
                errors.append(
                    f"{node['name']}.{column}: expected {expected_description!r}, "
                    f"found {actual_description!r}"
                )
            if not declared_type:
                errors.append(f"{node['name']}.{column}: missing data_type")
            elif str(declared_type).lower() != actual_type:
                errors.append(
                    f"{node['name']}.{column}: data_type {declared_type!r} "
                    f"does not match compiled type {actual_type!r}"
                )
            expected_definitions[doc_name] = (owner_id, owner_column)
            if doc_name != local_doc_id(node, column):
                reused_assignments += 1

    for doc_name, (owner_id, owner_column) in sorted(expected_definitions.items()):
        definition = definitions.get(doc_name)
        if definition is None:
            errors.append(f"missing docs block: {doc_name}")
            continue
        path, body = definition
        if len(body.split()) < 5:
            errors.append(f"{path.relative_to(ROOT)}: {doc_name} is too shallow")
        owner_node = models[owner_id]
        if is_staging(owner_node):
            expected_path = (
                ROOT
                / "projects"
                / "shared"
                / Path(owner_node["original_file_path"]).with_suffix(".md")
            )
        else:
            project_folder = package_folders[owner_node["package_name"]]
            expected_path = (
                ROOT
                / "projects"
                / project_folder
                / Path(owner_node["original_file_path"]).with_suffix(".md")
            )
        if path != expected_path:
            errors.append(
                f"{doc_name}: defined in {path.relative_to(ROOT)}, expected {expected_path.relative_to(ROOT)}"
            )

    namespaces = {project_doc_namespace(package) for package in package_folders}
    for doc_name in sorted(definitions):
        parts = doc_name.split("__")
        if len(parts) == 3 and parts[0] in namespaces and doc_name not in expected_definitions:
            errors.append(f"unused or misplaced column docs block: {doc_name}")

    if errors:
        print("Column documentation checks failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1

    print(
        "Column docs: "
        f"{len(models)} models, "
        f"{model_assignments} columns, "
        f"{reused_assignments} inherited references, "
        f"{len(expected_definitions)} unique definitions"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
