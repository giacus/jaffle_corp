#!/usr/bin/env python3
"""Require every enabled legacy model to share the fixture deprecation horizon."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "target" / "manifest.json"
EXPECTED_DATE = "2030-01-01"


def enabled_legacy_models(manifest: dict) -> list[dict]:
    return sorted(
        (
            node
            for node in manifest.get("nodes", {}).values()
            if node.get("resource_type") == "model"
            and node.get("package_name") == "legacy"
            and node.get("config", {}).get("enabled", True)
        ),
        key=lambda node: node.get("unique_id", ""),
    )


def invalid_legacy_model_ids(legacy_models: list[dict]) -> list[str]:
    return [
        node.get("unique_id", "<unknown>")
        for node in legacy_models
        if not str(node.get("deprecation_date") or "").startswith(EXPECTED_DATE)
    ]


def main() -> None:
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    legacy_models = enabled_legacy_models(manifest)
    if not legacy_models:
        raise SystemExit("Legacy deprecations: no enabled legacy models found in target/manifest.json")

    invalid = invalid_legacy_model_ids(legacy_models)
    if invalid:
        details = "\n  - ".join(invalid)
        raise SystemExit(
            f"Legacy deprecations: expected {EXPECTED_DATE} for every enabled legacy model:\n  - {details}"
        )

    print(f"Legacy deprecations: {len(legacy_models)} enabled models use {EXPECTED_DATE}")


if __name__ == "__main__":
    main()
