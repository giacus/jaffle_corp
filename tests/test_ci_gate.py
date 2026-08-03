from __future__ import annotations

import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def gate(
    *,
    full_required: bool,
    scope: str = "success",
    markdown: str = "success",
    static: str = "success",
    full: str = "success",
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [
            sys.executable,
            "scripts/check_ci_gate.py",
            "--full-required",
            str(full_required).lower(),
            "--scope",
            scope,
            "--markdown",
            markdown,
            "--static",
            static,
            "--full",
            full,
        ],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )


class CiGateTests(unittest.TestCase):
    def test_required_layers_succeed(self) -> None:
        result = gate(full_required=True)

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_required_full_validation_cannot_be_skipped(self) -> None:
        result = gate(full_required=True, full="skipped")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("full validation must succeed", result.stderr)

    def test_inapplicable_full_validation_must_be_skipped(self) -> None:
        result = gate(full_required=False, full="skipped")

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_inapplicable_full_validation_cannot_hide_an_unexpected_run(self) -> None:
        result = gate(full_required=False, full="success")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("full validation must be skipped", result.stderr)

    def test_always_required_layer_cannot_be_skipped(self) -> None:
        result = gate(full_required=False, markdown="skipped", full="skipped")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("markdown must succeed", result.stderr)


if __name__ == "__main__":
    unittest.main()
