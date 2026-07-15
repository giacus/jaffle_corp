#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"

CATALOG_PROJECT="projects/catalog"

if ! command -v dbt >/dev/null 2>&1; then
  echo "dbt is not available. Run scripts/bootstrap.sh, then source .venv/bin/activate." >&2
  exit 1
fi

export DBT_PROFILES_DIR="${DBT_PROFILES_DIR:-$ROOT_DIR}"
export JAFFLE_CORP_DUCKDB_PATH="${JAFFLE_CORP_DUCKDB_PATH:-$ROOT_DIR/jaffle_corp.duckdb}"

echo "Installing catalog dependencies..."
dbt deps --project-dir "$CATALOG_PROJECT" --profiles-dir "$DBT_PROFILES_DIR"

echo "Compiling the complete jaffle-corp catalog..."
dbt compile \
  --project-dir "$CATALOG_PROJECT" \
  --profiles-dir "$DBT_PROFILES_DIR" \
  --target-path "$ROOT_DIR/target"

MANIFEST_PATH="$ROOT_DIR/target/manifest.json"

if [[ ! -f "$MANIFEST_PATH" ]]; then
  echo "Catalog compile finished without producing $MANIFEST_PATH" >&2
  exit 1
fi

python - "$ROOT_DIR" "$MANIFEST_PATH" <<'PY'
import json
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
manifest_path = Path(sys.argv[2])
manifest = json.loads(manifest_path.read_text())

expected_projects = set()
for project_file in sorted((root / "projects").glob("*/dbt_project.yml")):
    match = re.search(r"(?m)^name:\s*([^\s#]+)", project_file.read_text())
    if match:
        expected_projects.add(match.group(1).strip('"\''))

represented_projects = {manifest["metadata"]["project_name"]}
for section in (
    "nodes",
    "sources",
    "exposures",
    "metrics",
    "semantic_models",
    "macros",
):
    represented_projects.update(
        resource["package_name"]
        for resource in manifest.get(section, {}).values()
        if "package_name" in resource
    )

missing_projects = sorted(expected_projects - represented_projects)
if missing_projects:
    raise SystemExit(
        "Full-project manifest is missing dbt projects: "
        + ", ".join(missing_projects)
    )

print(
    "Catalog coverage: "
    f"{len(expected_projects)} projects, "
    f"{len(manifest.get('nodes', {}))} nodes, "
    f"{len(manifest.get('sources', {}))} sources, "
    f"{len(manifest.get('metrics', {}))} metrics, "
    f"{len(manifest.get('semantic_models', {}))} semantic models."
)
PY

echo
echo "Full-project manifest: $MANIFEST_PATH"
