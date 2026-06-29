#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

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
  find projects -mindepth 2 -maxdepth 2 -name dbt_project.yml -print \
    | sed 's#/dbt_project.yml$##' \
    | sort
)

if [[ "${#dbt_projects[@]}" -eq 0 ]]; then
  echo "Bootstrap failed: no dbt projects found under projects/." >&2
  exit 1
fi

for project in "${dbt_projects[@]}"; do
  if [[ -f "$project/packages.yml" ]]; then
    echo "Installing dbt packages for $project"
    (
      cd "$project"
      dbt deps
    )
  fi
done

for project in "${dbt_projects[@]}"; do
  echo "Compiling $project"
  (
    cd "$project"
    dbt compile
  )
done

cat <<EOF

Bootstrap complete.

Next shell:
  source .venv/bin/activate

Smoke test:
  cd <any projects/* folder with dbt_project.yml>
  dbt compile
EOF
