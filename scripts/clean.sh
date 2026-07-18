#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"

KEEP_VENV=0
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: scripts/clean.sh [--keep-venv] [--dry-run]

Remove generated jaffle-corp state without touching tracked source files.

Options:
  --keep-venv  Preserve .venv while removing DuckDB data, dbt packages,
               targets, logs, generated docs, and Python/tool caches.
  --dry-run    List what would be removed without deleting it.
  -h, --help   Show this help.

Run without options at the end of a workshop to reclaim all local disk space,
including the repository virtual environment.
EOF
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --keep-venv)
      KEEP_VENV=1
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ ! -f "$ROOT_DIR/profiles.yml" || ! -d "$ROOT_DIR/projects" ]]; then
  echo "Refusing to clean: $ROOT_DIR is not a jaffle-corp checkout." >&2
  exit 1
fi

if ! git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Refusing to clean: Git metadata is required for the source-safety check." >&2
  exit 1
fi

paths=()

add_path() {
  local candidate="$1"
  [[ -e "$candidate" || -L "$candidate" ]] || return 0
  paths+=("$candidate")
}

add_path "$ROOT_DIR/target"
add_path "$ROOT_DIR/logs"
add_path "$ROOT_DIR/.pytest_cache"
add_path "$ROOT_DIR/.ruff_cache"

while IFS= read -r path; do
  add_path "$path"
done < <(
  find "$ROOT_DIR/projects" "$ROOT_DIR/scripts" \
    -type d \
    \( -name target -o -name logs -o -name dbt_packages -o -name __pycache__ \
       -o -name .pytest_cache -o -name .ruff_cache \) \
    -prune \
    -print \
    | sort
)

while IFS= read -r path; do
  add_path "$path"
done < <(
  find "$ROOT_DIR" \
    \( -path "$ROOT_DIR/.git" -o -path "$ROOT_DIR/.venv" \) -prune -o \
    -type f \( -name '*.duckdb' -o -name '*.duckdb.wal' \) -print \
    | sort
)

if [[ "$KEEP_VENV" -eq 0 ]]; then
  add_path "$ROOT_DIR/.venv"
fi

if [[ "${#paths[@]}" -eq 0 ]]; then
  echo "Nothing to clean."
  exit 0
fi

for path in "${paths[@]}"; do
  case "$path" in
    "$ROOT_DIR"/*) ;;
    *)
      echo "Refusing to clean a path outside the checkout: $path" >&2
      exit 1
      ;;
  esac

  relative_path="${path#"$ROOT_DIR"/}"
  if ! git -C "$ROOT_DIR" check-ignore -q -- "$relative_path"; then
    echo "Refusing to clean a path that is not ignored by Git: $relative_path" >&2
    exit 1
  fi
  tracked_files="$(
    git -C "$ROOT_DIR" ls-files -- "$relative_path" "$relative_path/**"
  )"
  if [[ -n "$tracked_files" ]]; then
    echo "Refusing to clean a path containing tracked files: $relative_path" >&2
    exit 1
  fi
done

total_kib=0
for path in "${paths[@]}"; do
  size_kib="$(du -sk "$path" 2>/dev/null | awk '{print $1}')"
  total_kib=$((total_kib + ${size_kib:-0}))
done

echo "Generated local state:"
for path in "${paths[@]}"; do
  printf '  %s\n' "${path#"$ROOT_DIR"/}"
done

if [[ "$DRY_RUN" -eq 1 ]]; then
  awk -v kib="$total_kib" 'BEGIN { printf "Would reclaim approximately %.1f MiB.\n", kib / 1024 }'
  exit 0
fi

for path in "${paths[@]}"; do
  rm -rf -- "$path"
done

awk -v kib="$total_kib" 'BEGIN { printf "Reclaimed approximately %.1f MiB.\n", kib / 1024 }'
if [[ "$KEEP_VENV" -eq 0 ]]; then
  echo "The virtual environment was removed. Run scripts/bootstrap.sh before the next session."
fi
