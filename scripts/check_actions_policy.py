#!/usr/bin/env python3
"""Require every repository-owned GitHub Actions workflow to be manual-only."""

from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
WORKFLOWS = ROOT / ".github" / "workflows"


def workflow_triggers(path: Path) -> list[str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    try:
        on_index = lines.index("on:")
    except ValueError as error:
        raise ValueError(f"{path.name}: missing top-level on block") from error

    triggers: list[str] = []
    for line in lines[on_index + 1 :]:
        if line and not line.startswith((" ", "#")):
            break
        if line.startswith("  ") and not line.startswith("   "):
            normalized = line.split(" #", maxsplit=1)[0].strip()
            if normalized:
                triggers.append(normalized)
    return triggers


def validate(workflows_root: Path = WORKFLOWS) -> list[Path]:
    workflows = sorted((*workflows_root.glob("*.yml"), *workflows_root.glob("*.yaml")))
    if not workflows:
        raise ValueError("Expected at least one manual GitHub Actions workflow")
    for workflow in workflows:
        triggers = workflow_triggers(workflow)
        if triggers != ["workflow_dispatch:"]:
            found = ", ".join(triggers) if triggers else "no triggers"
            raise ValueError(
                f"{workflow.name}: GitHub Actions must be manual-only; found {found}"
            )
    return workflows


if __name__ == "__main__":
    checked = validate()
    print(f"Manual-only Actions policy passed for {len(checked)} workflow(s).")
