from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RepoPolicyTests(unittest.TestCase):
    def make_repo(self) -> Path:
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        (root / ".github/workflows").mkdir(parents=True)
        (root / "scripts").mkdir()
        (root / ".python-version").write_text("3.11.9\n", encoding="utf-8")
        (root / "requirements.txt").write_text("demo==1.0\n", encoding="utf-8")
        (root / "requirements.lock.txt").write_text("demo==1.0\n", encoding="utf-8")
        (root / ".github/workflows/ci.yml").write_text(
            "jobs:\n"
            "  static:\n"
            "    steps:\n"
            "      - uses: actions/setup-python@v6\n"
            "        with:\n"
            "          python-version-file: .python-version\n",
            encoding="utf-8",
        )
        (root / "Taskfile.yml").write_text(
            "version: '3'\ntasks:\n  check:\n    cmds:\n      - scripts/check.sh\n",
            encoding="utf-8",
        )
        script = root / "scripts/check.sh"
        script.write_text("#!/usr/bin/env bash\n", encoding="utf-8")
        script.chmod(0o755)
        subprocess.run(["git", "init", "-q"], cwd=root, check=True)
        subprocess.run(["git", "add", "."], cwd=root, check=True)
        return root

    def run_policy(self, root: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, "scripts/check_repo_policy.py", "--root", str(root)],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )

    def test_valid_repository_passes(self) -> None:
        result = self.run_policy(self.make_repo())

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_direct_requirement_must_match_the_lock(self) -> None:
        root = self.make_repo()
        (root / "requirements.txt").write_text("demo==2.0\n", encoding="utf-8")

        result = self.run_policy(root)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("demo==2.0 is absent from requirements.lock.txt", result.stderr)

    def test_generated_artifacts_cannot_be_tracked(self) -> None:
        root = self.make_repo()
        artifact = root / "target/manifest.json"
        artifact.parent.mkdir()
        artifact.write_text("{}\n", encoding="utf-8")
        subprocess.run(["git", "add", "-f", "target/manifest.json"], cwd=root, check=True)

        result = self.run_policy(root)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("tracked generated artifact: target/manifest.json", result.stderr)

    def test_actions_python_setup_uses_the_repository_version_file(self) -> None:
        root = self.make_repo()
        (root / ".github/workflows/ci.yml").write_text(
            "jobs:\n"
            "  static:\n"
            "    steps:\n"
            "      - uses: actions/setup-python@v6\n"
            "        with:\n"
            "          python-version: '3.11'\n",
            encoding="utf-8",
        )

        result = self.run_policy(root)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("setup-python must use python-version-file", result.stderr)

    def test_taskfile_script_commands_must_exist(self) -> None:
        root = self.make_repo()
        (root / "Taskfile.yml").write_text(
            "version: '3'\ntasks:\n  check:\n    cmds:\n      - scripts/missing.sh\n",
            encoding="utf-8",
        )

        result = self.run_policy(root)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Taskfile command does not exist: scripts/missing.sh", result.stderr)


if __name__ == "__main__":
    unittest.main()
