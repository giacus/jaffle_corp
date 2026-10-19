#!/usr/bin/env python3
"""Focused, dependency-free checks for the dbt 2 fixture verifier."""
from pathlib import Path
import stat
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))
import verify_dbt2_semantic_graph as verifier


class VerifierTests(unittest.TestCase):
    def test_edge_view_mismatch_is_reported(self):
        manifest = {
            "nodes": {"model.example.x": {"depends_on": {"nodes": ["source.example.x"]}}},
            "sources": {"source.example.x": {}},
            "parent_map": {"model.example.x": ["source.example.x"]},
            "child_map": {"source.example.x": []},
        }
        graph = verifier.graph_sets(manifest)
        self.assertFalse(graph["edgeParity"])

    def test_dangling_dependencies_only_reports_absent_ids(self):
        manifest = {
            "metrics": {
                "metric.example.other": {"depends_on": {"nodes": []}},
                "metric.example.present": {"depends_on": {"nodes": ["metric.example.other"]}},
                "metric.example.missing": {"depends_on": {"nodes": ["semantic_model.example.absent"]}},
            },
        }
        self.assertEqual(
            verifier.dangling_dependencies(manifest),
            {"metric.example.missing": ["semantic_model.example.absent"]},
        )

    def test_wrong_runtime_is_rejected(self):
        with tempfile.TemporaryDirectory(prefix="dbt-verifier-test-") as temp:
            executable = Path(temp) / "dbt"
            executable.write_text("#!/bin/sh\nprintf 'dbt 2.0.7\\n'\n")
            executable.chmod(executable.stat().st_mode | stat.S_IXUSR)
            with self.assertRaises(SystemExit):
                verifier.resolve_dbt(executable)

    def test_failed_runtime_with_matching_banner_is_rejected(self):
        with tempfile.TemporaryDirectory(prefix="dbt-verifier-test-") as temp:
            executable = Path(temp) / "dbt"
            executable.write_text("#!/bin/sh\nprintf 'dbt 2.0.6\\n'\nexit 1\n")
            executable.chmod(executable.stat().st_mode | stat.S_IXUSR)
            with self.assertRaises(SystemExit):
                verifier.resolve_dbt(executable)

    def test_baseline_must_be_in_os_temp_and_is_non_overwriting(self):
        with tempfile.TemporaryDirectory(prefix="dbt-verifier-test-") as temp:
            source = Path(temp) / "source"
            source.mkdir()
            (source / "manifest.json").write_text("{}\n")
            destination = Path(temp) / "baseline"
            verifier.copy_baseline(source, destination, {}, Path("/tmp/dbt"))
            self.assertEqual((destination / "manifest.json").read_text(), "{}\n")
            with self.assertRaises(SystemExit):
                verifier.copy_baseline(source, destination, {}, Path("/tmp/dbt"))
            with self.assertRaises(SystemExit):
                verifier.copy_baseline(source, verifier.ROOT / "unsafe-baseline", {}, Path("/tmp/dbt"))


if __name__ == "__main__":
    unittest.main()
