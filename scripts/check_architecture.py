#!/usr/bin/env python3
"""Enforce public-only cross-project model dependencies."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, default=ROOT / "target/manifest.json")
    args = parser.parse_args()

    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    nodes = manifest.get("nodes", {})
    errors: list[str] = []
    cross_project_edges = 0

    for child_id, parent_ids in manifest.get("parent_map", {}).items():
        child = nodes.get(child_id)
        if not child or child.get("resource_type") != "model":
            continue
        for parent_id in parent_ids:
            parent = nodes.get(parent_id)
            if not parent or parent.get("resource_type") != "model":
                continue
            child_package = child.get("package_name")
            parent_package = parent.get("package_name")
            if child_package == parent_package:
                continue
            cross_project_edges += 1
            if parent_package == "shared":
                continue
            access = parent.get("access") or parent.get("config", {}).get("access")
            if access != "public":
                errors.append(
                    f"{child_package}.{child['name']} depends on non-public "
                    f"{parent_package}.{parent['name']}"
                )

    if errors:
        print("Architecture policy checks failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in sorted(errors)), file=sys.stderr)
        return 1

    print(
        "Architecture policy: "
        f"{cross_project_edges} cross-project model edges target public models "
        "or the shared package exception"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
