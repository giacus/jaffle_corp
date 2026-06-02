#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
export JAFFLE_CORP_DUCKDB_PATH="${JAFFLE_CORP_DUCKDB_PATH:-$ROOT_DIR/jaffle_corp.duckdb}"

PROJECTS=(
  projects/jaffle_platform
  projects/jaffle_supply
  projects/jaffle_finance
  projects/jaffle_experience
  projects/jaffle_growth
  projects/jaffle_store_ops
  projects/jaffle_merchandising
  projects/jaffle_planning
  projects/jaffle_legacy
)

SEED_PROJECTS=(
  projects/jaffle_platform
  projects/jaffle_supply
  projects/jaffle_experience
  projects/jaffle_store_ops
  projects/jaffle_merchandising
  projects/jaffle_planning
)

for project in "${PROJECTS[@]}"; do
  dbt deps --project-dir "$project" --profiles-dir .
done

scripts/lint_sql_projects.sh
scripts/check_sanitization.sh

for project in "${SEED_PROJECTS[@]}"; do
  dbt seed --project-dir "$project" --profiles-dir .
done

for project in "${PROJECTS[@]}"; do
  dbt build --project-dir "$project" --profiles-dir .
done

python scripts/run_semantic_inputs.py
