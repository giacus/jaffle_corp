#!/usr/bin/env python3
"""Check cheap repository invariants that should gate every pull request."""

from __future__ import annotations

import argparse
import os
import re
import shlex
import subprocess
import sys
from pathlib import Path

import yaml


EXACT_REQUIREMENT = re.compile(r"^(?P<name>[A-Za-z0-9_.-]+)==(?P<version>[^\s]+)$")
GENERATED_DIRECTORIES = {
    ".pytest_cache",
    ".ruff_cache",
    ".venv",
    "__pycache__",
    "dbt_packages",
    "logs",
    "target",
}


def requirement_lines(path: Path) -> set[str]:
    return {
        line.strip()
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    }


def normalized_requirement(requirement: str) -> tuple[str, str] | None:
    match = EXACT_REQUIREMENT.fullmatch(requirement)
    if match is None:
        return None
    name = re.sub(r"[-_.]+", "-", match.group("name")).casefold()
    return name, match.group("version")


def is_generated(path: str) -> bool:
    parts = Path(path).parts
    name = Path(path).name
    return (
        any(part in GENERATED_DIRECTORIES for part in parts)
        or name == ".DS_Store"
        or name.endswith((".duckdb", ".duckdb.wal", ".log"))
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    root = args.root.resolve()

    errors: list[str] = []
    direct = requirement_lines(root / "requirements.txt")
    locked = requirement_lines(root / "requirements.lock.txt")
    locked_requirements = {
        parsed
        for requirement in locked
        if (parsed := normalized_requirement(requirement)) is not None
    }
    for requirement in sorted(direct):
        parsed = normalized_requirement(requirement)
        if parsed is None:
            errors.append(f"{requirement} is not an exact requirement")
        elif parsed not in locked_requirements:
            errors.append(f"{requirement} is absent from requirements.lock.txt")

    tracked = subprocess.check_output(
        ["git", "ls-files", "-z"], cwd=root
    ).decode("utf-8").split("\0")
    errors.extend(
        f"tracked generated artifact: {path}"
        for path in tracked
        if path and is_generated(path)
    )

    python_version = (root / ".python-version").read_text(encoding="utf-8").strip()
    if not re.fullmatch(r"3[.]11[.][0-9]+", python_version):
        errors.append(".python-version must pin an exact Python 3.11 patch release")

    taskfile = yaml.safe_load((root / "Taskfile.yml").read_text(encoding="utf-8"))
    for task in (taskfile.get("tasks", {}) or {}).values():
        for raw_command in task.get("cmds", []) or []:
            command = raw_command.get("cmd") if isinstance(raw_command, dict) else raw_command
            if not isinstance(command, str):
                continue
            tokens = shlex.split(command)
            if not tokens or not tokens[0].startswith("scripts/"):
                continue
            script_path = root / tokens[0]
            if not script_path.is_file():
                errors.append(f"Taskfile command does not exist: {tokens[0]}")
            elif not os.access(script_path, os.X_OK):
                errors.append(f"Taskfile command is not executable: {tokens[0]}")

    if errors:
        print("Repository policy checks failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1

    print(
        "Repository policy: dependency, generated-artifact, Python, "
        "and Taskfile checks passed"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
