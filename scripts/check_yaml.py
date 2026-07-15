#!/usr/bin/env python3
"""Parse repository YAML and reject duplicate mapping keys."""

from __future__ import annotations

import sys
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]
IGNORED_PARTS = {".git", ".venv", "dbt_packages", "logs", "target"}


class UniqueKeyLoader(yaml.SafeLoader):
    pass


def construct_mapping(loader: UniqueKeyLoader, node: yaml.MappingNode, deep: bool = False):
    mapping = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if key in mapping:
            raise yaml.constructor.ConstructorError(
                "while constructing a mapping",
                node.start_mark,
                f"found duplicate key {key!r}",
                key_node.start_mark,
            )
        mapping[key] = loader.construct_object(value_node, deep=deep)
    return mapping


UniqueKeyLoader.add_constructor(
    yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
    construct_mapping,
)


def yaml_files() -> list[Path]:
    return [
        path
        for path in sorted(ROOT.rglob("*"))
        if path.suffix in {".yml", ".yaml"}
        and not any(part in IGNORED_PARTS for part in path.relative_to(ROOT).parts)
    ]


def main() -> int:
    errors: list[str] = []
    for path in yaml_files():
        relative = path.relative_to(ROOT)
        text = path.read_text(encoding="utf-8")
        if text and not text.endswith("\n"):
            errors.append(f"{relative}: missing final newline")
        try:
            yaml.load(text, Loader=UniqueKeyLoader)
        except yaml.YAMLError as error:
            errors.append(f"{relative}: {error}")

    if errors:
        print("YAML checks failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1

    print(f"YAML: {len(yaml_files())} files, 0 parse or duplicate-key errors")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
