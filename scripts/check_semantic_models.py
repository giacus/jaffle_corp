#!/usr/bin/env python3
"""Verify that simple Semantic Layer expressions reference declared model columns."""

from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parents[1]
PROJECTS = ROOT / "projects"
REF = re.compile(
    r"^\s*ref\(\s*(?P<quote>['\"])(?P<model>[A-Za-z_][A-Za-z0-9_]*)"
    r"(?P=quote)\s*\)\s*$"
)
IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
SEMANTIC_OBJECTS = ("entities", "dimensions", "measures")


def relative(path: Path) -> str:
    return str(path.relative_to(ROOT))


def load_yaml(path: Path, errors: list[str]) -> Any:
    try:
        return yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as exc:
        errors.append(f"{relative(path)}: could not load YAML: {exc}")
        return {}


def owning_project(path: Path) -> Path | None:
    for parent in path.parents:
        if (parent / "dbt_project.yml").is_file():
            return parent
        if parent == PROJECTS:
            break
    return None


def declared_models(project: Path, errors: list[str]) -> dict[str, set[str]]:
    """Load model-to-column declarations from YAML in one dbt project."""
    declarations: dict[str, list[tuple[Path, set[str]]]] = defaultdict(list)

    yaml_paths = sorted(
        path
        for path in (project / "models").rglob("*")
        if path.suffix in {".yml", ".yaml"}
    )
    for path in yaml_paths:
        document = load_yaml(path, errors)
        if not isinstance(document, dict):
            errors.append(f"{relative(path)}: expected a top-level YAML mapping")
            continue
        models = document.get("models", []) or []
        if not isinstance(models, list):
            errors.append(f"{relative(path)}: 'models' must be a list")
            continue

        for model in models:
            if not isinstance(model, dict) or not isinstance(model.get("name"), str):
                errors.append(f"{relative(path)}: every model declaration needs a string name")
                continue
            columns = model.get("columns", []) or []
            if not isinstance(columns, list):
                errors.append(
                    f"{relative(path)}: model {model['name']!r} has a non-list 'columns' value"
                )
                continue
            names: set[str] = set()
            for column in columns:
                name = column.get("name") if isinstance(column, dict) else None
                if not isinstance(name, str):
                    errors.append(
                        f"{relative(path)}: model {model['name']!r} has a column without a string name"
                    )
                    continue
                names.add(name.casefold())
            declarations[model["name"]].append((path, names))

    resolved: dict[str, set[str]] = {}
    for name, matches in declarations.items():
        if len(matches) > 1:
            locations = ", ".join(relative(path) for path, _ in matches)
            errors.append(
                f"{project.name}: model {name!r} is declared more than once: {locations}"
            )
            continue
        resolved[name] = matches[0][1]
    return resolved


def semantic_files() -> list[Path]:
    return sorted(PROJECTS.glob("*/models/**/semantic_models.yml"))


def main() -> int:
    errors: list[str] = []
    files = semantic_files()
    projects: set[Path] = set()
    model_count = 0
    expression_count = 0
    simple_expression_count = 0
    declarations_by_project: dict[Path, dict[str, set[str]]] = {}

    for path in files:
        project = owning_project(path)
        if project is None:
            errors.append(f"{relative(path)}: could not find an owning dbt_project.yml")
            continue
        projects.add(project)
        if project not in declarations_by_project:
            declarations_by_project[project] = declared_models(project, errors)
        declarations = declarations_by_project[project]

        document = load_yaml(path, errors)
        if not isinstance(document, dict):
            errors.append(f"{relative(path)}: expected a top-level YAML mapping")
            continue
        semantic_models = document.get("semantic_models", []) or []
        if not isinstance(semantic_models, list):
            errors.append(f"{relative(path)}: 'semantic_models' must be a list")
            continue

        for semantic_model in semantic_models:
            model_count += 1
            if not isinstance(semantic_model, dict):
                errors.append(f"{relative(path)}: every semantic model must be a mapping")
                continue
            semantic_name = semantic_model.get("name")
            if not isinstance(semantic_name, str):
                errors.append(f"{relative(path)}: every semantic model needs a string name")
                semantic_name = "<unnamed>"

            model_reference = semantic_model.get("model")
            match = REF.fullmatch(model_reference) if isinstance(model_reference, str) else None
            if match is None:
                errors.append(
                    f"{relative(path)}: semantic model {semantic_name!r} must use a "
                    "single-argument ref() for 'model'"
                )
                backing_model = None
                declared_columns: set[str] = set()
            else:
                backing_model = match.group("model")
                declared_columns = declarations.get(backing_model, set())
                if backing_model not in declarations:
                    errors.append(
                        f"{relative(path)}: semantic model {semantic_name!r} references "
                        f"undeclared model {backing_model!r} in project {project.name!r}"
                    )
                    backing_model = None
                elif not declared_columns:
                    errors.append(
                        f"{relative(path)}: backing model {backing_model!r} has no declared columns"
                    )

            for object_type in SEMANTIC_OBJECTS:
                objects = semantic_model.get(object_type, []) or []
                if not isinstance(objects, list):
                    errors.append(
                        f"{relative(path)}: semantic model {semantic_name!r} has a "
                        f"non-list {object_type!r} value"
                    )
                    continue
                for semantic_object in objects:
                    expression_count += 1
                    if not isinstance(semantic_object, dict):
                        errors.append(
                            f"{relative(path)}: {semantic_name}.{object_type} contains "
                            "a non-mapping value"
                        )
                        continue
                    object_name = semantic_object.get("name")
                    if not isinstance(object_name, str):
                        errors.append(
                            f"{relative(path)}: {semantic_name}.{object_type} contains "
                            "an object without a string name"
                        )
                        continue
                    expression = semantic_object.get("expr")
                    if expression is None:
                        expression = object_name
                    if not isinstance(expression, str):
                        continue
                    expression = expression.strip()
                    if not IDENTIFIER.fullmatch(expression):
                        continue
                    simple_expression_count += 1
                    if backing_model is not None and expression.casefold() not in declared_columns:
                        errors.append(
                            f"{relative(path)}: {semantic_name}.{object_type}.{object_name} "
                            f"references absent column {expression!r} on {backing_model!r}"
                        )

    summary = (
        "Semantic models: "
        f"{len(projects)} projects, "
        f"{model_count} models, "
        f"{expression_count} expressions, "
        f"{simple_expression_count} simple column references"
    )
    if errors:
        print("Semantic model checks failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        print(summary, file=sys.stderr)
        return 1

    print(summary)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
