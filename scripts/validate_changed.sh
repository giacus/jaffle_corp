#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"

BASE_SHA="${1:-}"
if [[ -z "$BASE_SHA" ]]; then
  echo "Usage: scripts/validate_changed.sh <base-sha>" >&2
  exit 2
fi

changed_files=()
while IFS= read -r file; do
  [[ -n "$file" ]] && changed_files+=("$file")
done < <(git diff --name-only "$BASE_SHA...HEAD")
printf 'Targeted dbt files:\n%s\n' "${changed_files[*]:-(none)}"

all_projects=()
while IFS= read -r project_file; do
  all_projects+=("$(dirname "$project_file")")
done < <(find projects -mindepth 2 -maxdepth 2 -name dbt_project.yml | sort)

global_change=false
projects=()
sql_files=()

add_project() {
  local candidate="$1"
  case " ${projects[*]-} " in
    *" $candidate "*) ;;
    *) projects+=("$candidate") ;;
  esac
}

for file in "${changed_files[@]}"; do
  case "$file" in
    requirements.txt|requirements.lock.txt|profiles.yml|.sqlfluff|scripts/bootstrap.sh|scripts/env.sh|scripts/generate_manifest.sh|scripts/install_venv_hook.sh|scripts/lint_sql_projects.sh|scripts/validate_changed.sh|scripts/validate_repo.sh|scripts/check_column_docs.py)
      global_change=true
      ;;
    projects/shared/*)
      global_change=true
      ;;
    projects/*/*)
      project_name="${file#projects/}"
      project="projects/${project_name%%/*}"
      [[ -f "$project/dbt_project.yml" ]] && add_project "$project"
      ;;
  esac
  if [[ -f "$file" && ("$file" == projects/*/*.sql || "$file" == projects/*/**/*.sql) ]]; then
    sql_files+=("$file")
  fi
done

if [[ "$global_change" == true ]]; then
  projects=("${all_projects[@]}")
fi

for project in "${projects[@]}"; do
  echo "Parsing $project"
  dbt deps --project-dir "$project" --profiles-dir .
  dbt parse --project-dir "$project" --profiles-dir . --no-partial-parse
done

if [[ "${#sql_files[@]}" -gt 0 ]]; then
  scripts/lint_sql_projects.sh "${sql_files[@]}"
else
  echo "No changed SQL files to lint."
fi
