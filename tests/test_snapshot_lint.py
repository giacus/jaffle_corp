from __future__ import annotations

import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import yaml

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("snapshot_lint", ROOT / "scripts/lint_sql_project.py")
lint = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lint)


class SnapshotLintTests(unittest.TestCase):
    def setUp(self) -> None:
        self.directory = tempfile.TemporaryDirectory(prefix="jaffle-snapshot-lint-test-")
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.project = self.root / "project"
        (self.project / "models").mkdir(parents=True)
        (self.project / "snapshots").mkdir()
        self.config = {
            "name": "lint_fixture", "version": "1.0", "config-version": 2,
            "profile": "lint_fixture", "snapshot-paths": ["snapshots"],
            "snapshots": {"lint_fixture": {"history": {"+tags": ["container_config"]}}},
        }
        (self.project / "dbt_project.yml").write_text(yaml.safe_dump(self.config))
        (self.root / "profiles.yml").write_text(yaml.safe_dump({"lint_fixture": {
            "target": "dev", "outputs": {"dev": {"type": "duckdb", "path": str(self.root / "lint.duckdb"), "threads": 1}}
        }}))
        (self.root / ".sqlfluff").write_text((ROOT / ".sqlfluff").read_text())
        for name in ["orders", "payments"]:
            (self.project / "models" / f"{name}.sql").write_text("select 1 as id\n")
        self.source = self.project / "snapshots/history.sql"
        self.source.write_text("\n".join(
            "{% snapshot " + name + "_history %}\n"
            "    {{ config(unique_key='id', strategy='check', check_cols='all', target_schema='audit') }}\n"
            "    select * from {{ ref('" + name + "') }}\n{% endsnapshot %}\n"
            for name in ["orders", "payments"]
        ))
        self.original = self.source.read_text()
        self.environment = {**os.environ, "PATH": str(Path(sys.executable).parent) + os.pathsep + os.environ["PATH"],
                            "DBT_SEND_ANONYMOUS_USAGE_STATS": "false"}

    def parse(self, project: Path, target: Path) -> dict:
        result = subprocess.run([str(Path(sys.executable).with_name("dbt")), "parse", "--no-partial-parse",
                                 "--project-dir", str(project), "--profiles-dir", str(self.root),
                                 "--target-path", str(target), "--log-path", str(target / "logs")],
                                env=self.environment, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        manifest = json.loads((target / "manifest.json").read_text())
        return {key: {field: node[field] for field in ["unique_id", "fqn", "config", "depends_on"]}
                for key, node in manifest["nodes"].items() if node["resource_type"] == "snapshot"}

    def run_lint(self) -> subprocess.CompletedProcess[str]:
        return subprocess.run([sys.executable, str(ROOT / "scripts/lint_sql_project.py"),
                               "--project", str(self.project), "--root", str(self.root), "snapshots"],
                              env=self.environment, capture_output=True, text=True)

    def test_preserves_snapshot_identity_config_and_dependencies_and_lints_the_second_block(self) -> None:
        expected = self.parse(self.project, self.root / "original-target")
        clone, replacements = lint.prepare_project(self.project, self.root / "clone", self.config,
                                                   lint.multiple_snapshots(self.project, self.config))
        actual = self.parse(clone, self.root / "clone-target")
        self.assertEqual(actual, expected)
        self.assertEqual(len(actual), 2)
        for name in ["orders", "payments"]:
            node = actual[f"snapshot.lint_fixture.{name}_history"]
            self.assertEqual(node["fqn"], ["lint_fixture", "history", f"{name}_history"])
            self.assertEqual(node["config"]["tags"], ["container_config"])
            self.assertEqual(node["depends_on"]["nodes"], [f"model.lint_fixture.{name}"])
        self.assertEqual(len(replacements[self.source]), 2)
        self.assertFalse((clone / "snapshots/history.sql").exists())
        self.assertEqual(self.source.read_text(), self.original)
        passing = self.run_lint()
        self.assertEqual(passing.returncode, 0, passing.stdout + passing.stderr)
        self.source.write_text(self.original.replace("select * from {{ ref('payments') }}", "SELECT * from {{ ref('payments') }}"))
        failing = self.run_lint()
        self.assertNotEqual(failing.returncode, 0, "a lint error in the second block must fail validation")
        self.assertIn("CP01", failing.stdout)
        self.assertIn(".sqlfluff-snapshot-blocks/1/history.sql", failing.stdout)

    def test_failed_lint_cleans_its_clone_and_preserves_original_source(self) -> None:
        visited = []

        def fail(_command, *, cwd, env):
            visited.append(cwd)
            self.assertTrue(cwd.exists())
            self.assertTrue(lint.inside(cwd, Path(env["DBT_TARGET_PATH"])))
            self.assertTrue(lint.inside(cwd, Path(env["DBT_LOG_PATH"])))
            return subprocess.CompletedProcess(_command, 1)

        with patch.object(lint.subprocess, "run", side_effect=fail):
            self.assertEqual(lint.lint_project(self.project, self.root, ["snapshots"]), 1)
        self.assertEqual(len(visited), 1)
        self.assertFalse(visited[0].exists())
        self.assertEqual(self.source.read_text(), self.original)

    def test_non_package_symlinks_cannot_escape_isolated_lint(self) -> None:
        external = self.root / "external"
        external.mkdir()
        marker = external / "protected.txt"
        marker.write_text("unchanged")
        (self.project / "custom_cache").symlink_to(external, target_is_directory=True)
        with self.assertRaisesRegex(ValueError, "non-package symlinks"):
            lint.lint_project(self.project, self.root, ["snapshots"])
        self.assertEqual(marker.read_text(), "unchanged")
        self.assertEqual(self.source.read_text(), self.original)

    def test_relative_local_package_links_stay_inside_temporary_workspace(self) -> None:
        dependency = self.root / "shared"
        dependency.mkdir()
        (dependency / "dbt_project.yml").write_text("name: shared\n")
        (self.project / "packages.yml").write_text("packages:\n  - local: ../shared\n")
        (self.project / "dbt_packages").mkdir()
        (self.project / "dbt_packages/shared").symlink_to(dependency)
        temporary = self.root / "clone"
        clone, _ = lint.prepare_project(self.project, temporary, self.config,
                                        lint.multiple_snapshots(self.project, self.config))
        self.assertEqual((clone.parent / "shared").resolve(), dependency.resolve())
        self.assertEqual((clone / "dbt_packages/shared").resolve(), dependency.resolve())
        self.assertTrue(lint.inside(temporary, clone.parent / "shared"))


if __name__ == "__main__":
    unittest.main()
