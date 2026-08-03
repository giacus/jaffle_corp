from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def public_model(columns: str) -> str:
    return (
        "version: 2\n"
        "models:\n"
        "  - name: orders\n"
        "    config:\n"
        "      access: public\n"
        "      contract:\n"
        "        enforced: true\n"
        "    columns:\n"
        f"{columns}"
    )


class PublicContractReportTests(unittest.TestCase):
    def make_repo(self, yaml_text: str) -> tuple[Path, str]:
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        model_path = root / "projects/finance/models/orders.yml"
        model_path.parent.mkdir(parents=True)
        model_path.write_text(yaml_text, encoding="utf-8")
        subprocess.run(["git", "init", "-q"], cwd=root, check=True)
        subprocess.run(["git", "add", "."], cwd=root, check=True)
        subprocess.run(
            [
                "git",
                "-c",
                "user.name=CI",
                "-c",
                "user.email=ci@example.invalid",
                "commit",
                "-qm",
                "base",
            ],
            cwd=root,
            check=True,
        )
        base = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip()
        return root, base

    def run_report(self, root: Path, base: str) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [
                sys.executable,
                "scripts/report_public_contract_changes.py",
                base,
                "--root",
                str(root),
            ],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )

    def test_reports_removed_and_retyped_public_columns(self) -> None:
        root, base = self.make_repo(
            public_model(
                "      - name: order_id\n"
                "        data_type: varchar\n"
                "      - name: amount\n"
                "        data_type: integer\n"
            )
        )
        (root / "projects/finance/models/orders.yml").write_text(
            public_model(
                "      - name: amount\n"
                "        data_type: decimal(18,2)\n"
            ),
            encoding="utf-8",
        )

        result = self.run_report(root, base)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("finance.orders: removed column `order_id`", result.stdout)
        self.assertIn(
            "finance.orders: changed `amount` from `integer` to `decimal(18,2)`",
            result.stdout,
        )

    def test_unchanged_public_contract_has_explicit_empty_report(self) -> None:
        root, base = self.make_repo(
            public_model("      - name: order_id\n        data_type: varchar\n")
        )

        result = self.run_report(root, base)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("No public contract changes", result.stdout)

    def test_protected_model_changes_are_not_public_contract_changes(self) -> None:
        protected = public_model(
            "      - name: order_id\n        data_type: varchar\n"
        ).replace("access: public", "access: protected")
        root, base = self.make_repo(protected)
        (root / "projects/finance/models/orders.yml").write_text(
            protected.replace("varchar", "integer"),
            encoding="utf-8",
        )

        result = self.run_report(root, base)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("No public contract changes", result.stdout)

    def test_versioned_public_contract_uses_version_identity(self) -> None:
        versioned = (
            "version: 2\n"
            "models:\n"
            "  - name: orders\n"
            "    config:\n"
            "      access: public\n"
            "      contract:\n"
            "        enforced: true\n"
            "    versions:\n"
            "      - v: 1\n"
            "        columns:\n"
            "          - name: order_id\n"
            "            data_type: varchar\n"
        )
        root, base = self.make_repo(versioned)
        (root / "projects/finance/models/orders.yml").write_text(
            versioned.replace("varchar", "integer"),
            encoding="utf-8",
        )

        result = self.run_report(root, base)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(
            "finance.orders.v1: changed `order_id` from `varchar` to `integer`",
            result.stdout,
        )


if __name__ == "__main__":
    unittest.main()
