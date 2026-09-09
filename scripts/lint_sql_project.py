#!/usr/bin/env python3
"""Lint multi-snapshot SQL with dbt's original per-block resource contexts.

SQLFluff 4.2 selects one manifest node per file. A temporary project separates
snapshot blocks into additional search roots while retaining each original
relative filename, and therefore its dbt FQN and project configuration.
"""
from __future__ import annotations

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

from dbt_common.clients.jinja import extract_toplevel_blocks
import yaml


def inside(root: Path, value: Path) -> bool:
    return value == root or root in value.parents


def project_path(project: Path, value: str) -> Path:
    result = Path(os.path.abspath(project / value))
    if not inside(project, result) or result == project:
        raise ValueError(f"SQL lint requires a project-contained path: {value}")
    return result


def multiple_snapshots(project: Path, config: dict) -> dict[Path, tuple[Path, list[str]]]:
    result = {}
    for root_name in config.get("snapshot-paths", ["snapshots"]):
        root = project_path(project, root_name)
        for file in sorted(root.rglob("*.sql")):
            if file.is_symlink():
                raise ValueError(f"Snapshot lint source must not be a symlink: {file}")
            blocks = extract_toplevel_blocks(file.read_text(), allowed_blocks={"snapshot"}, collect_raw_data=False)
            if len(blocks) > 1:
                if len(blocks) > 64 or len({block.block_name for block in blocks}) != len(blocks):
                    raise ValueError(f"Snapshot lint requires at most 64 unique blocks: {file}")
                if file in result:
                    raise ValueError(f"Overlapping snapshot search roots: {file}")
                result[file] = (file.relative_to(root), [block.full_block for block in blocks])
    return result


def prepare_project(project: Path, temporary: Path, config: dict, containers: dict) -> tuple[Path, dict[Path, list[Path]]]:
    clone = temporary / "workspace" / "projects" / project.name
    clone.parent.mkdir(parents=True)
    generated_name = ".sqlfluff-snapshot-blocks"
    if (project / generated_name).exists() or (project / generated_name).is_symlink():
        raise ValueError(f"Reserved validation directory already exists: {generated_name}")
    package_name = config.get("packages-install-path", "dbt_packages")
    package_root = project_path(project, package_name)
    target_root = project_path(project, config.get("target-path", "target"))
    excluded = {".git", ".venv", "logs", "target", "dbt_packages", package_root.relative_to(project).parts[0], target_root.relative_to(project).parts[0]}
    def ignore_generated(directory: str, names: list[str]) -> list[str]:
        ignored = [name for name in names if Path(directory) == project and name in excluded]
        for name in names:
            if name not in ignored and (Path(directory) / name).is_symlink():
                raise ValueError(f"Isolated SQL lint rejects non-package symlinks: {Path(directory) / name}")
        return ignored

    shutil.copytree(project, clone, ignore=ignore_generated)
    # Installed local packages often use relative symlinks; bind every installed
    # package to its original resolved source, without running dbt deps here.
    clone_packages = clone / "dbt_packages"
    clone_packages.mkdir()
    if package_root.exists():
        for package in package_root.iterdir():
            (clone_packages / package.name).symlink_to(package.resolve(), target_is_directory=package.is_dir())
    # Preserve declared relative local-package layouts too. All links are inside
    # the temporary tree; compilation never runs cleanup or dependency install.
    for name in ["packages.yml", "dependencies.yml"]:
        file = project / name
        if not file.exists():
            continue
        data = yaml.safe_load(file.read_text()) or {}
        for declaration in data.get("packages", []):
            local = declaration.get("local")
            if not isinstance(local, str) or Path(local).is_absolute():
                continue
            original = (project / local).resolve(strict=True)
            destination = Path(os.path.abspath(clone / local))
            if not inside(temporary, destination) or inside(clone, destination):
                raise ValueError(f"Unsupported local-package layout for isolated lint: {local}")
            if destination.exists():
                if destination.resolve() != original:
                    raise ValueError(f"Conflicting local-package layout for isolated lint: {local}")
                continue
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.symlink_to(original, target_is_directory=True)
    roots = list(config.get("snapshot-paths", ["snapshots"]))
    replacements = {}
    ordinal = 0
    for file, (relative, blocks) in containers.items():
        (clone / file.relative_to(project)).unlink()
        replacements[file] = []
        for block in blocks:
            root = Path(generated_name) / str(ordinal)
            ordinal += 1
            target = clone / root / relative
            target.parent.mkdir(parents=True)
            target.write_text(block + "\n")
            roots.append(root.as_posix())
            replacements[file].append(target.relative_to(clone))
    clone_config = {**config, "snapshot-paths": roots, "packages-install-path": "dbt_packages", "target-path": "target"}
    (clone / "dbt_project.yml").write_text(yaml.safe_dump(clone_config, sort_keys=False))
    return clone, replacements


def lint_project(project: Path, root: Path, targets: list[str]) -> int:
    project = project.resolve(strict=True)
    config = yaml.safe_load((project / "dbt_project.yml").read_text())
    containers = multiple_snapshots(project, config)
    selected = [project_path(project, target) for target in targets]
    needs_split = any(any(inside(target, file) for target in selected) for file in containers)

    def run(directory: Path, paths: list[str], isolated: bool = False) -> int:
        environment = {**os.environ, "DBT_PROFILES_DIR": str(root)}
        if isolated:
            environment.update(DBT_TARGET_PATH=str(directory / "target"), DBT_LOG_PATH=str(directory / "logs"), DBT_PARTIAL_PARSE="false")
        return subprocess.run(["sqlfluff", "lint", "--config", str(root / ".sqlfluff"), *paths], cwd=directory, env=environment).returncode

    if not needs_split:
        return run(project, targets)
    with tempfile.TemporaryDirectory(prefix="jaffle-snapshot-lint-") as directory:
        clone, replacements = prepare_project(project, Path(directory), config, containers)
        paths = [target for target in targets if project_path(project, target) not in replacements]
        for file, blocks in replacements.items():
            if any(inside(target, file) for target in selected):
                print(f"Linting each snapshot block from {file.relative_to(project)} with its own dbt context", flush=True)
                paths.extend(block.as_posix() for block in blocks)
        return run(clone, list(dict.fromkeys(paths)), isolated=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", type=Path, required=True)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("targets", nargs="+")
    arguments = parser.parse_args()
    raise SystemExit(lint_project(arguments.project, arguments.root.resolve(strict=True), arguments.targets))
