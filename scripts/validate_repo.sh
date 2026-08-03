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

# shared owns every raw fixture seed. Seeding through one importing
# project loads the complete raw layer once without repeating it per domain.
dbt seed --project-dir "$SEED_PROJECT" --profiles-dir .

# Customer Experience owns this compact operating policy rather than treating
# it as a landed source fixture.
dbt seed \
  --project-dir projects/experience \
  --profiles-dir . \
  --select order_status_follow_up_policy

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
    --select reliability \
    --exclude resource_type:seed
done

run_analysis_preview() {
  local project="$1"
  local analysis="$2"
  dbt show \
    --project-dir "$project" \
    --profiles-dir . \
    --select "$analysis" \
    --limit 20 \
    --quiet >/dev/null
}

for project_file in projects/*/dbt_project.yml; do
  analysis_project="${project_file%/dbt_project.yml}"
  [[ -d "$analysis_project/analyses" ]] || continue

  while IFS= read -r analysis_file; do
    analysis_name="${analysis_file##*/}"
    analysis_name="${analysis_name%.sql}"
    echo "Checking ${analysis_project#projects/}.${analysis_name} analysis"
    run_analysis_preview "$analysis_project" "$analysis_name"
  done < <(find "$analysis_project/analyses" -type f -name '*.sql' | sort)
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

run_metricflow_saved_query() {
  local project="$1"
  local saved_query="$2"
  (
    cd "$project"
    DBT_PROFILES_DIR="$ROOT_DIR" mf query \
      --saved-query "$saved_query" \
      --limit 20 \
      --quiet
  )
}

for semantic_file in projects/*/models/semantic_models.yml; do
  [[ -f "$semantic_file" ]] || continue
  run_metricflow_validate "${semantic_file%/models/semantic_models.yml}"
done

run_metricflow_query \
  projects/platform \
  "order_count,item_quantity" \
  "metric_time"

run_metricflow_query \
  projects/supply \
  "supply_risk_rate,late_purchase_order_rate" \
  "metric_time,location,component"

run_metricflow_query \
  projects/finance \
  "net_revenue_usd,estimated_gross_margin_usd,refund_rate,year_to_date_net_revenue_usd" \
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
  "attributed_net_revenue_usd,campaign_roas,campaign_contribution_usd" \
  "metric_time,campaign_performance__campaign_id,campaign_performance__channel"

run_metricflow_saved_query \
  projects/growth \
  "weekly_campaign_performance"

run_metricflow_query \
  projects/experience \
  "experiment_conversion_rate,seven_day_experiment_conversion_rate" \
  "metric_time,experiment_outcome__experiment_id,experiment_outcome__variant_id"

run_metricflow_query \
  projects/store_ops \
  "kitchen_ready_target_rate,store_ops_quality_exception_count,store_ops_incident_count" \
  "metric_time,location,store_day_operations__store_day_status"

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
