#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"
DEFAULT_DUCKDB_PATH="$ROOT_DIR/jaffle_corp.duckdb"
export JAFFLE_CORP_DUCKDB_PATH="${JAFFLE_CORP_DUCKDB_PATH:-$DEFAULT_DUCKDB_PATH}"

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

EXTENSION_PROJECTS=(
  projects/jaffle_reliability
)

SEED_PROJECTS=(
  projects/jaffle_platform
  projects/jaffle_supply
  projects/jaffle_experience
  projects/jaffle_store_ops
  projects/jaffle_merchandising
  projects/jaffle_planning
)

ALL_PROJECTS=("${PROJECTS[@]}" "${EXTENSION_PROJECTS[@]}")

if [[ "$JAFFLE_CORP_DUCKDB_PATH" == "$DEFAULT_DUCKDB_PATH" ]]; then
  rm -f "$JAFFLE_CORP_DUCKDB_PATH" "$JAFFLE_CORP_DUCKDB_PATH.wal"
  find "$ROOT_DIR/projects" \
    \( -name "*.duckdb" -o -name "*.duckdb.wal" \) \
    -type f \
    -delete
fi

for project in "${ALL_PROJECTS[@]}"; do
  rm -rf "$project/target" "$project/dbt_packages"
done

for project in "${ALL_PROJECTS[@]}"; do
  dbt deps --project-dir "$project" --profiles-dir .
done

scripts/lint_sql_projects.sh

for project in "${SEED_PROJECTS[@]}"; do
  dbt seed --project-dir "$project" --profiles-dir .
done

for project in "${PROJECTS[@]}"; do
  dbt build --project-dir "$project" --profiles-dir .
done

for project in "${EXTENSION_PROJECTS[@]}"; do
  dbt build --project-dir "$project" --profiles-dir . --select jaffle_reliability
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

run_metricflow_validate projects/jaffle_finance
run_metricflow_validate projects/jaffle_growth
run_metricflow_validate projects/jaffle_merchandising
run_metricflow_validate projects/jaffle_planning

run_metricflow_query \
  projects/jaffle_finance \
  "net_revenue_usd,estimated_gross_margin_usd,refund_rate" \
  "metric_time,location,order__country_code"

run_metricflow_query \
  projects/jaffle_growth \
  "attributed_net_revenue_usd,campaign_roas" \
  "metric_time,campaign_performance__campaign_id,campaign_performance__channel"

run_metricflow_query \
  projects/jaffle_merchandising \
  "merchandising_observed_hours,merchandising_available_hours,merchandising_availability_rate,merchandising_outage_minutes" \
  "metric_time,product,location,product_store_hour__availability_status,product_store_hour__product_family"

run_metricflow_query \
  projects/jaffle_merchandising \
  "menu_actual_units,menu_target_units,menu_unit_attainment_rate" \
  "metric_time,location,menu_goal__product_family,menu_goal__unit_goal_status"

run_metricflow_query \
  projects/jaffle_planning \
  "planned_component_usage,actual_component_usage" \
  "metric_time,location,component,component_week_plan__scenario_name,component_week_plan__usage_variance_status"

run_metricflow_query \
  projects/jaffle_planning \
  "forecasted_orders,actual_orders_for_forecast,absolute_order_forecast_error,forecast_interval_hit_rate" \
  "metric_time,location,store_hour_forecast__scenario_name,store_hour_forecast__forecast_accuracy_band"
