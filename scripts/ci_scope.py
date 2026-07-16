#!/usr/bin/env python3
"""Classify changed files for the layered GitHub Actions workflow."""

from __future__ import annotations

import argparse
import os
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DBT_GLOBAL_FILES = {
    ".sqlfluff",
    "Taskfile.yml",
    "profiles.yml",
    "requirements.txt",
    "requirements.lock.txt",
}
DBT_SCRIPTS = {
    "scripts/bootstrap.sh",
    "scripts/check_column_docs.py",
    "scripts/check_semantic_models.py",
    "scripts/clean.sh",
    "scripts/docs.sh",
    "scripts/env.sh",
    "scripts/generate_manifest.sh",
    "scripts/install_venv_hook.sh",
    "scripts/lint_sql_projects.sh",
    "scripts/validate_changed.sh",
    "scripts/validate_repo.sh",
}
DBT_SUFFIXES = {".csv", ".md", ".sql", ".yaml", ".yml"}


def git(*args: str) -> str:
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()


def resolve_base(event: str, explicit_base: str | None) -> str:
    if explicit_base:
        return explicit_base
    if event == "pull_request":
        base_ref = os.environ.get("GITHUB_BASE_REF", "master")
        return git("merge-base", f"origin/{base_ref}", "HEAD")
    if event == "push":
        before = os.environ.get("EVENT_BEFORE", "")
        if before and set(before) != {"0"}:
            return before
        return git("rev-parse", "HEAD^")
    return git("rev-parse", "HEAD")


def changed_files(base: str) -> list[str]:
    output = git("diff", "--name-only", f"{base}...HEAD")
    return [line for line in output.splitlines() if line]


def is_dbt_change(path: str) -> bool:
    file_path = Path(path)
    return (
        path in DBT_GLOBAL_FILES
        or path in DBT_SCRIPTS
        or (path.startswith("projects/") and file_path.suffix in DBT_SUFFIXES)
    )


def write_output(path: str | None, values: dict[str, str]) -> None:
    for key, value in values.items():
        print(f"{key}={value}")
    if path:
        with Path(path).open("a", encoding="utf-8") as handle:
            for key, value in values.items():
                handle.write(f"{key}={value}\n")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--event", default=os.environ.get("GITHUB_EVENT_NAME", "pull_request"))
    parser.add_argument("--base")
    parser.add_argument("--files", nargs="*")
    parser.add_argument("--github-output", default=os.environ.get("GITHUB_OUTPUT"))
    args = parser.parse_args()

    base = resolve_base(args.event, args.base)
    files = (
        args.files
        if args.files is not None
        else [] if args.event in {"schedule", "workflow_dispatch"} else changed_files(base)
    )
    dbt_changed = any(is_dbt_change(path) for path in files)
    force_full = args.event in {"schedule", "workflow_dispatch"}

    print("Changed files:")
    print("\n".join(files) if files else "(none or forced full run)")
    write_output(
        args.github_output,
        {
            "base_sha": base,
            "dbt_changed": str(dbt_changed).lower(),
            "full_validate": str(force_full or dbt_changed).lower(),
        },
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
