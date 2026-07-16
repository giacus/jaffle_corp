#!/usr/bin/env python3
"""Check repository Markdown links and lightweight, deterministic style rules."""

from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote


ROOT = Path(__file__).resolve().parents[1]
IGNORED_PARTS = {".git", ".venv", "dbt_packages", "logs", "target"}
LINK_PATTERN = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
CODE_SPAN_PATTERN = re.compile(r"(?<!`)`([^`\n]+)`(?!`)")
HEADING_PATTERN = re.compile(r"^(#{1,6})\s+\S")
REPOSITORY_PATH_PREFIXES = ("docs/", "projects/", "scripts/")


def markdown_files() -> list[Path]:
    return [
        path
        for path in sorted(ROOT.rglob("*.md"))
        if not any(part in IGNORED_PARTS for part in path.relative_to(ROOT).parts)
    ]


def main() -> int:
    errors: list[str] = []
    link_count = 0
    path_count = 0

    for path in markdown_files():
        relative = path.relative_to(ROOT)
        text = path.read_text(encoding="utf-8")
        lines = text.splitlines()

        if text and not text.endswith("\n"):
            errors.append(f"{relative}: missing final newline")

        fence: str | None = None
        previous_heading = 0
        for number, line in enumerate(lines, start=1):
            if line.rstrip() != line:
                errors.append(f"{relative}:{number}: trailing whitespace")

            fence_match = re.match(r"^\s*(```+|~~~+)", line)
            if fence_match:
                marker = fence_match.group(1)[0]
                fence = None if fence == marker else marker
                continue

            if fence is not None:
                continue

            for code_span in CODE_SPAN_PATTERN.findall(line):
                if not code_span.startswith(REPOSITORY_PATH_PREFIXES):
                    continue
                if any(marker in code_span for marker in (" ", "*", "<", ">")):
                    continue
                repository_path = code_span.rstrip("/")
                path_count += 1
                if not (ROOT / repository_path).exists():
                    errors.append(
                        f"{relative}:{number}: missing repository path -> {repository_path}"
                    )

            heading = HEADING_PATTERN.match(line)
            if heading:
                level = len(heading.group(1))
                if previous_heading and level > previous_heading + 1:
                    errors.append(
                        f"{relative}:{number}: heading jumps from H{previous_heading} to H{level}"
                    )
                previous_heading = level

        if fence is not None:
            errors.append(f"{relative}: unclosed fenced code block")

        for raw_target in LINK_PATTERN.findall(text):
            target = raw_target.strip().split(' "', 1)[0].strip("<>")
            if not target or target.startswith(("#", "http://", "https://", "mailto:")):
                continue
            target_path = unquote(target.split("#", 1)[0])
            link_count += 1
            if not (path.parent / target_path).exists():
                errors.append(f"{relative}: broken relative link -> {target_path}")

    if errors:
        print("Markdown checks failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1

    print(
        f"Markdown: {len(markdown_files())} files, {link_count} relative links, "
        f"{path_count} repository paths, 0 errors"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
