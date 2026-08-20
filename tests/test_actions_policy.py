import tempfile
import unittest
from pathlib import Path

from scripts.check_actions_policy import validate, workflow_triggers


class ActionsPolicyTests(unittest.TestCase):
    def test_repository_workflows_are_manual_only(self) -> None:
        workflows = validate()
        self.assertEqual([path.name for path in workflows], ["ci.yml"])

    def test_automatic_trigger_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workflows = Path(temporary_directory)
            workflow = workflows / "ci.yml"
            workflow.write_text(
                "name: invalid\non:\n  pull_request:\n  workflow_dispatch:\njobs: {}\n",
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "manual-only"):
                validate(workflows)

    def test_manual_inputs_are_allowed(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workflows = Path(temporary_directory)
            workflow = workflows / "ci.yml"
            workflow.write_text(
                "name: manual\non:\n  workflow_dispatch:\n    inputs:\n"
                "      reason:\n        required: false\njobs: {}\n",
                encoding="utf-8",
            )
            self.assertEqual(workflow_triggers(workflow), ["workflow_dispatch:"])
            self.assertEqual(validate(workflows), [workflow])


if __name__ == "__main__":
    unittest.main()
