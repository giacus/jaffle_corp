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

rm -rf "$ROOT_DIR/target" "$ROOT_DIR/logs"
find "$ROOT_DIR/projects" \
  -mindepth 2 \
  -maxdepth 2 \
  -type d \
  \( -name target -o -name dbt_packages -o -name logs \) \
  -prune \
  -exec rm -rf {} +

if [[ "$JAFFLE_CORP_DUCKDB_PATH" == "$DEFAULT_DUCKDB_PATH" ]]; then
  rm -f "$JAFFLE_CORP_DUCKDB_PATH" "$JAFFLE_CORP_DUCKDB_PATH.wal"
  find "$ROOT_DIR/projects" \
    \( -name "*.duckdb" -o -name "*.duckdb.wal" \) \
    -type f \
    -delete
fi

for project in "${DEPENDENCY_PROJECTS[@]}"; do
  rm -rf "$project/target" "$project/dbt_packages"
done

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

run_metricflow_validate projects/finance
run_metricflow_validate projects/growth
run_metricflow_validate projects/merchandising
run_metricflow_validate projects/planning

run_metricflow_query \
  projects/finance \
  "net_revenue_usd,estimated_gross_margin_usd,refund_rate" \
  "metric_time,location,order__country_code"

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
