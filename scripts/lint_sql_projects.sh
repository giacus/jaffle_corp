#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v sqlfluff >/dev/null 2>&1; then
  echo "sqlfluff is not installed. Run: python -m pip install -r requirements.txt" >&2
  exit 127
fi

project_dirs=()

if [[ "$#" -gt 0 ]]; then
  for file in "$@"; do
    case "$file" in
      projects/*/*.sql|projects/*/**/*.sql|extensions/*/*.sql|extensions/*/**/*.sql)
        project_root="${file%%/*}"
        project_rest="${file#*/}"
        project="$project_root/${project_rest%%/*}"
        ;;
      *)
        continue
        ;;
    esac
    project_dirs+=("$project")
  done
else
  for source_root in "$ROOT_DIR/projects" "$ROOT_DIR/extensions"; do
    [[ -d "$source_root" ]] || continue
    while IFS= read -r -d '' project_file; do
      project_dirs+=("$(dirname "$project_file")")
    done < <(find "$source_root" -mindepth 2 -maxdepth 2 -name dbt_project.yml -print0)
  done
fi

if [[ "${#project_dirs[@]}" -eq 0 ]]; then
  echo "No project SQL files to lint."
  exit 0
fi

unique_projects=()
while IFS= read -r project; do
  unique_projects+=("$project")
done < <(printf '%s\n' "${project_dirs[@]}" | sort -u)

for project in "${unique_projects[@]}"; do
  if [[ "$project" = /* ]]; then
    project_path="$project"
    project_label="${project#"$ROOT_DIR/"}"
  else
    project_path="$ROOT_DIR/$project"
    project_label="$project"
  fi
  args=()

  if [[ "$#" -gt 0 ]]; then
    for file in "$@"; do
      case "$file" in
        "$project"/*.sql|"$project"/**/*.sql)
          args+=("${file#"$project/"}")
          ;;
      esac
    done
  else
    for source_dir in models analyses tests snapshots macros; do
      if [[ -d "$project_path/$source_dir" ]]; then
        args+=("$source_dir")
      fi
    done
  fi

  if [[ "${#args[@]}" -eq 0 ]]; then
    continue
  fi

  echo "Linting $project_label"
  (
    cd "$project_path"
    DBT_PROFILES_DIR="$ROOT_DIR" sqlfluff lint --config "$ROOT_DIR/.sqlfluff" "${args[@]}"
  )
done
