#!/usr/bin/env python3
"""Require the exact GitHub Actions layers selected for a change."""

from __future__ import annotations

import argparse
import sys


def boolean(value: str) -> bool:
    normalized = value.casefold()
    if normalized == "true":
        return True
    if normalized == "false":
        return False
    raise argparse.ArgumentTypeError("expected true or false")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--full-required", required=True, type=boolean)
    parser.add_argument("--scope", required=True)
    parser.add_argument("--markdown", required=True)
    parser.add_argument("--static", required=True)
    parser.add_argument("--full", required=True)
    args = parser.parse_args()

    errors = [
        f"{name} must succeed; received {result}"
        for name, result in (
            ("scope", args.scope),
            ("markdown", args.markdown),
            ("static", args.static),
        )
        if result != "success"
    ]

    if args.full_required and args.full != "success":
        errors.append(f"full validation must succeed; received {args.full}")
    if not args.full_required and args.full != "skipped":
        errors.append(f"full validation must be skipped; received {args.full}")

    if errors:
        print("CI gate failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1

    print("CI gate: every required validation layer completed exactly once")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
