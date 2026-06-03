# MetricFlow Commands

Run these from a built local checkout after installing `requirements.txt`, running `dbt deps`, seeding the source projects, and building the dbt projects in README order.

The Semantic Layer files are intentionally compact:

- `models/semantic_models.yml` contains semantic models.
- `models/metrics.yml` contains metrics.
- Add `models/saved_queries.yml` only when you want to version a reusable query.

No Python wrapper is required. Set the repo-root DuckDB path once, then run
MetricFlow from the dbt project that owns the metrics you want to inspect:

```bash
export JAFFLE_CORP_DUCKDB_PATH="$PWD/jaffle_corp.duckdb"
cd projects/jaffle_finance
export DBT_PROFILES_DIR=../..
mf list metrics
mf list dimensions --metrics <metric_name>
mf list entities --metrics <metric_name>
cd ../..
```

`DBT_PROFILES_DIR` is required here because MetricFlow reads the active dbt
project, but the shared `profiles.yml` lives at the repository root.

## Finance

```bash
cd projects/jaffle_finance
export DBT_PROFILES_DIR=../..
mf validate-configs --skip-dw
mf query \
  --metrics net_revenue_usd,estimated_gross_margin_usd,refund_rate \
  --group-by metric_time,location,order__country_code \
  --limit 20
cd ../..
```

## Growth

```bash
cd projects/jaffle_growth
export DBT_PROFILES_DIR=../..
mf validate-configs --skip-dw
mf query \
  --metrics attributed_net_revenue_usd,campaign_roas \
  --group-by metric_time,campaign_performance__campaign_id,campaign_performance__channel \
  --limit 20
cd ../..
```

## Merchandising

```bash
cd projects/jaffle_merchandising
export DBT_PROFILES_DIR=../..
mf validate-configs --skip-dw
mf query \
  --metrics merchandising_observed_hours,merchandising_available_hours,merchandising_availability_rate,merchandising_outage_minutes \
  --group-by metric_time,product,location,product_store_hour__availability_status,product_store_hour__product_family \
  --limit 20
mf query \
  --metrics menu_actual_units,menu_target_units,menu_unit_attainment_rate \
  --group-by metric_time,location,menu_goal__product_family,menu_goal__unit_goal_status \
  --limit 20
cd ../..
```

## Planning

```bash
cd projects/jaffle_planning
export DBT_PROFILES_DIR=../..
mf validate-configs --skip-dw
mf query \
  --metrics planned_component_usage,actual_component_usage \
  --group-by metric_time,location,component,component_week_plan__scenario_name,component_week_plan__usage_variance_status \
  --limit 20
mf query \
  --metrics forecasted_orders,actual_orders_for_forecast,absolute_order_forecast_error,forecast_interval_hit_rate \
  --group-by metric_time,location,store_hour_forecast__scenario_name,store_hour_forecast__forecast_accuracy_band \
  --limit 20
cd ../..
```
