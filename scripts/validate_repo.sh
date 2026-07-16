#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"
DEFAULT_DUCKDB_PATH="$ROOT_DIR/jaffle_corp.duckdb"
export JAFFLE_CORP_DUCKDB_PATH="${JAFFLE_CORP_DUCKDB_PATH:-$DEFAULT_DUCKDB_PATH}"

PROJECTS=(
  projects/platform
  projects/supply
  projects/finance
  projects/experience
  projects/growth
  projects/store_ops
  projects/merchandising
  projects/planning
  projects/legacy
)

EXTENSION_PROJECTS=(
  projects/reliability
)

SEED_PROJECT="projects/platform"

ALL_PROJECTS=("${PROJECTS[@]}" "${EXTENSION_PROJECTS[@]}")
DEPENDENCY_PROJECTS=(projects/shared "${ALL_PROJECTS[@]}")

if [[ "$JAFFLE_CORP_DUCKDB_PATH" != "$DEFAULT_DUCKDB_PATH" ]]; then
  echo "Using an external JAFFLE_CORP_DUCKDB_PATH; only generated state inside this checkout will be reset."
fi
scripts/clean.sh --keep-venv
python scripts/check_semantic_models.py

for project in "${DEPENDENCY_PROJECTS[@]}"; do
  dbt deps --project-dir "$project" --profiles-dir .
done

scripts/lint_sql_projects.sh

# jaffle_shared owns every raw fixture seed. Seeding through one importing
# project loads the complete raw layer once without repeating it per domain.
dbt seed --project-dir "$SEED_PROJECT" --profiles-dir .

for project in "${PROJECTS[@]}"; do
  dbt build \
    --project-dir "$project" \
    --profiles-dir . \
    --exclude resource_type:seed
done

for project in "${EXTENSION_PROJECTS[@]}"; do
  dbt build \
    --project-dir "$project" \
    --profiles-dir . \
    --select jaffle_reliability \
    --exclude resource_type:seed
done

run_metricflow_validate() {
  local project="$1"
  (
    cd "$project"
    DBT_PROFILES_DIR="$ROOT_DIR" mf validate-configs --skip-dw
  )
}

run_metricflow_query() {
  local project="$1"
  local metrics="$2"
  local group_by="$3"
  (
    cd "$project"
    DBT_PROFILES_DIR="$ROOT_DIR" mf query \
      --metrics "$metrics" \
      --group-by "$group_by" \
      --limit 20 \
      --quiet
  )
}

for semantic_file in projects/*/models/semantic_models.yml; do
  [[ -f "$semantic_file" ]] || continue
  run_metricflow_validate "${semantic_file%/models/semantic_models.yml}"
done

run_metricflow_query \
  projects/finance \
  "net_revenue_usd,estimated_gross_margin_usd,refund_rate" \
  "metric_time,location,order__country_code"

# Exercise the Finance semantic model's primary entity explicitly. This guards
# against advertising an entity whose expression is absent from the backing
# mart, which broader dimension-based queries can otherwise miss.
run_metricflow_query \
  projects/finance \
  "net_revenue_usd" \
  "order_revenue"

run_metricflow_query \
  projects/growth \
  "attributed_net_revenue_usd,campaign_roas" \
  "metric_time,campaign_performance__campaign_id,campaign_performance__channel"

run_metricflow_query \
  projects/merchandising \
  "merchandising_observed_hours,merchandising_available_hours,merchandising_availability_rate,merchandising_outage_minutes" \
  "metric_time,product,location,product_store_hour__availability_status,product_store_hour__product_family"

run_metricflow_query \
  projects/merchandising \
  "menu_actual_units,menu_target_units,menu_unit_attainment_rate" \
  "metric_time,location,menu_goal__product_family,menu_goal__unit_goal_status"

run_metricflow_query \
  projects/planning \
  "planned_component_usage,actual_component_usage" \
  "metric_time,location,component,component_week_plan__scenario_name,component_week_plan__usage_variance_status"

run_metricflow_query \
  projects/planning \
  "forecasted_orders,actual_orders_for_forecast,absolute_order_forecast_error,forecast_interval_hit_rate" \
  "metric_time,location,store_hour_forecast__scenario_name,store_hour_forecast__forecast_accuracy_band"

scripts/generate_manifest.sh
python scripts/check_column_docs.py
