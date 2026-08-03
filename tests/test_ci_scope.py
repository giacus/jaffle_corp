from __future__ import annotations

import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def classify(*files: str, event: str = "pull_request") -> dict[str, str]:
    command = [
        sys.executable,
        "scripts/ci_scope.py",
        "--event",
        event,
        "--base",
        "HEAD",
        "--files",
        *files,
    ]
    result = subprocess.run(
        command,
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    return dict(
        line.split("=", 1)
        for line in result.stdout.splitlines()
        if "=" in line
    )


class CiScopeTests(unittest.TestCase):
    def test_project_change_requires_integration(self) -> None:
        result = classify("projects/finance/models/marts/example.sql")

        self.assertEqual(result["full_validate"], "true")

    def test_root_documentation_skips_integration(self) -> None:
        result = classify("README.md")

        self.assertEqual(result["full_validate"], "false")

    def test_ci_control_and_lint_configuration_changes_require_integration(self) -> None:
        for path in (
            ".github/workflows/ci.yml",
            ".sqlfluffignore",
            "scripts/check_architecture.py",
            "scripts/ci_scope.py",
        ):
            with self.subTest(path=path):
                result = classify(path)
                self.assertEqual(result["full_validate"], "true")

    def test_taskfile_and_python_patch_pin_use_fast_checks_only(self) -> None:
        result = classify("Taskfile.yml", ".python-version")

        self.assertEqual(result["full_validate"], "false")

    def test_docs_script_requires_docs_generation(self) -> None:
        result = classify("scripts/docs.sh")

        self.assertEqual(result["full_validate"], "true")
        self.assertEqual(result["docs_changed"], "true")

    def test_schedule_forces_integration_without_changed_files(self) -> None:
        result = classify(event="schedule")

        self.assertEqual(result["full_validate"], "true")


if __name__ == "__main__":
    unittest.main()
