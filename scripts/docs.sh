#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"

CATALOG_PROJECT="projects/catalog"
TARGET_DIR="$ROOT_DIR/target"
COMMAND="${1:-generate}"
DOCS_PORT="${DBT_DOCS_PORT:-8080}"

usage() {
  cat <<'EOF'
Usage: scripts/docs.sh [generate|serve]

Generate or serve the complete local dbt documentation site.

  generate  Resolve catalog dependencies and write the site to target/.
  serve     Serve an existing generated site. Set DBT_DOCS_PORT to override
            the default http://localhost:8080 address.
EOF
}

case "$COMMAND" in
  generate|serve) ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown command: $COMMAND" >&2
    usage >&2
    exit 2
    ;;
esac

if ! command -v dbt >/dev/null 2>&1; then
  echo "dbt is not available. Run scripts/bootstrap.sh, then source .venv/bin/activate." >&2
  exit 1
fi

export DBT_PROFILES_DIR="${DBT_PROFILES_DIR:-$ROOT_DIR}"
export JAFFLE_CORP_DUCKDB_PATH="${JAFFLE_CORP_DUCKDB_PATH:-$ROOT_DIR/jaffle_corp.duckdb}"

if [[ "$COMMAND" == "generate" ]]; then
  echo "Installing catalog dependencies..."
  dbt deps --project-dir "$CATALOG_PROJECT" --profiles-dir "$DBT_PROFILES_DIR"

  echo "Generating full-project dbt docs..."
  dbt docs generate \
    --project-dir "$CATALOG_PROJECT" \
    --profiles-dir "$DBT_PROFILES_DIR" \
    --target-path "$TARGET_DIR"

  echo
  echo "Generated docs: $TARGET_DIR/index.html"
  echo "Serve them with: scripts/docs.sh serve"
  exit 0
fi

if [[ ! -f "$TARGET_DIR/index.html" || ! -f "$TARGET_DIR/manifest.json" \
  || ! -f "$TARGET_DIR/catalog.json" ]]; then
  echo "Generated docs were not found in target/. Run scripts/docs.sh generate first." >&2
  exit 1
fi

echo "Serving dbt docs at http://localhost:$DOCS_PORT (press Ctrl-C to stop)."
dbt docs serve \
  --project-dir "$CATALOG_PROJECT" \
  --profiles-dir "$DBT_PROFILES_DIR" \
  --target-path "$TARGET_DIR" \
  --port "$DOCS_PORT" \
  --no-browser
