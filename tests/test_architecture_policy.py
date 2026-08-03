from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def model(unique_id: str, package: str, access: str) -> dict:
    return {
        "unique_id": unique_id,
        "name": unique_id.rsplit(".", 1)[-1],
        "package_name": package,
        "resource_type": "model",
        "access": access,
    }


class ArchitecturePolicyTests(unittest.TestCase):
    def run_check(self, manifest: dict) -> subprocess.CompletedProcess[str]:
        with tempfile.NamedTemporaryFile(mode="w", suffix=".json") as handle:
            json.dump(manifest, handle)
            handle.flush()
            return subprocess.run(
                [
                    sys.executable,
                    "scripts/check_architecture.py",
                    "--manifest",
                    handle.name,
                ],
                cwd=ROOT,
                capture_output=True,
                text=True,
            )

    def test_cross_project_model_dependency_must_target_public_model(self) -> None:
        parent = model("model.finance.private_margin", "finance", "protected")
        child = model("model.growth.customer_value", "growth", "public")
        manifest = {
            "nodes": {parent["unique_id"]: parent, child["unique_id"]: child},
            "parent_map": {child["unique_id"]: [parent["unique_id"]]},
        }

        result = self.run_check(manifest)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn(
            "growth.customer_value depends on non-public finance.private_margin",
            result.stderr,
        )

    def test_public_same_project_and_shared_dependencies_are_allowed(self) -> None:
        cases = (
            ("finance", "public"),
            ("shared", "protected"),
            ("growth", "protected"),
        )
        for parent_package, access in cases:
            with self.subTest(parent_package=parent_package, access=access):
                parent = model(
                    f"model.{parent_package}.upstream_model",
                    parent_package,
                    access,
                )
                child = model("model.growth.customer_value", "growth", "public")
                manifest = {
                    "nodes": {
                        parent["unique_id"]: parent,
                        child["unique_id"]: child,
                    },
                    "parent_map": {child["unique_id"]: [parent["unique_id"]]},
                }

                result = self.run_check(manifest)

                self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
