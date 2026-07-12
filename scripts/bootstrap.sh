#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"

FULL_CHECK=0

usage() {
  cat <<EOF
Usage: scripts/bootstrap.sh [--full]

Sets up the local Python/dbt toolchain and runs a fast dbt smoke compile.

Options:
  --full    Compile every runnable project and generate the full-project manifest.
EOF
}

case "${1:-}" in
  "")
    ;;
  --full)
    FULL_CHECK=1
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage >&2
    exit 1
    ;;
esac

PYTHON_BIN="${PYTHON:-}"

if [[ -z "$PYTHON_BIN" ]]; then
  for candidate in python3.11 python3.12 python3; do
    if command -v "$candidate" >/dev/null 2>&1; then
      PYTHON_BIN="$candidate"
      break
    fi
  done
fi

if [[ -z "$PYTHON_BIN" ]]; then
  echo "Could not find Python. Install Python 3.11 or 3.12, then rerun this script." >&2
  exit 1
fi

python_version="$("$PYTHON_BIN" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
case "$python_version" in
  3.11|3.12) ;;
  *)
    echo "Unsupported Python version: $python_version" >&2
    echo "Use Python 3.11 or 3.12. Example: PYTHON=python3.11 scripts/bootstrap.sh" >&2
    exit 1
    ;;
esac

if [[ ! -d .venv ]]; then
  "$PYTHON_BIN" -m venv .venv
fi

bash scripts/install_venv_hook.sh

# shellcheck disable=SC1091
source .venv/bin/activate

python -m pip install --upgrade pip
python -m pip install -r requirements.txt

if [[ "${DBT_PROFILES_DIR:-}" != "$ROOT_DIR" ]]; then
  echo "Bootstrap failed: DBT_PROFILES_DIR was not set to the repository root." >&2
  echo "Expected: $ROOT_DIR" >&2
  echo "Actual: ${DBT_PROFILES_DIR:-<unset>}" >&2
  exit 1
fi

if [[ "${JAFFLE_CORP_DUCKDB_PATH:-}" != "$ROOT_DIR/jaffle_corp.duckdb" ]]; then
  echo "Bootstrap failed: JAFFLE_CORP_DUCKDB_PATH was not set correctly." >&2
  echo "Expected: $ROOT_DIR/jaffle_corp.duckdb" >&2
  echo "Actual: ${JAFFLE_CORP_DUCKDB_PATH:-<unset>}" >&2
  exit 1
fi

dbt_projects=()
while IFS= read -r project; do
  dbt_projects+=("$project")
done < <(
  find projects -mindepth 2 -maxdepth 2 -name dbt_project.yml \
    ! -path 'projects/jaffle_catalog/dbt_project.yml' \
    ! -path 'projects/jaffle_shared/dbt_project.yml' \
    -print \
    | sed 's#/dbt_project.yml$##' \
    | sort
)

if [[ "${#dbt_projects[@]}" -eq 0 ]]; then
  echo "Bootstrap failed: no dbt projects found under projects/." >&2
  exit 1
fi

projects_to_compile=()

if [[ "$FULL_CHECK" -eq 1 ]]; then
  projects_to_compile=("${dbt_projects[@]}")
else
  preferred_smoke_project="projects/jaffle_platform"

  if [[ -f "$preferred_smoke_project/dbt_project.yml" ]]; then
    projects_to_compile=("$preferred_smoke_project")
  fi

  for project in "${dbt_projects[@]}"; do
    if [[ "${#projects_to_compile[@]}" -gt 0 ]]; then
      break
    fi

    if [[ -f "$project/packages.yml" ]]; then
      projects_to_compile=("$project")
      break
    fi
  done

  if [[ "${#projects_to_compile[@]}" -eq 0 ]]; then
    projects_to_compile=("${dbt_projects[0]}")
  fi
fi

if [[ "$FULL_CHECK" -eq 1 ]]; then
  echo "Running full dbt compile across ${#projects_to_compile[@]} discovered projects."
else
  echo "Running dbt smoke compile in ${projects_to_compile[0]}."
fi

for project in "${projects_to_compile[@]}"; do
  if [[ -f "$project/packages.yml" ]]; then
    echo "Installing dbt packages for $project"
    (
      cd "$project"
      dbt deps
    )
  fi
done

for project in "${projects_to_compile[@]}"; do
  echo "Compiling $project"
  (
    cd "$project"
    dbt compile
  )
done

if [[ "$FULL_CHECK" -eq 1 ]]; then
  scripts/generate_manifest.sh
fi

cat <<EOF

Bootstrap complete.

Next shell:
  source .venv/bin/activate

Smoke test:
  cd <any projects/* folder with dbt_project.yml>
  dbt compile

Full project compile:
  scripts/bootstrap.sh --full
EOF
