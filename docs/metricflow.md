# MetricFlow Commands

Run these from a built local checkout after installing `requirements.txt`, running `dbt deps`, seeding the source projects, and building the dbt projects in README order.

Use the repo-root DuckDB file explicitly so `mf` opens the same database that dbt built:

```bash
export JAFFLE_CORP_DUCKDB_PATH="$PWD/jaffle_corp.duckdb"
```

## Finance

```bash
cd projects/jaffle_finance
DBT_PROFILES_DIR=../.. mf validate-configs --skip-dw
DBT_PROFILES_DIR=../.. mf query \
  --metrics net_revenue_usd,estimated_gross_margin_usd,refund_rate \
  --group-by metric_time,location,order__country_code \
  --limit 20
cd ../..
```

## Growth

```bash
cd projects/jaffle_growth
DBT_PROFILES_DIR=../.. mf validate-configs --skip-dw
DBT_PROFILES_DIR=../.. mf query \
  --metrics attributed_net_revenue_usd,campaign_roas \
  --group-by metric_time,campaign_performance__campaign_id,campaign_performance__channel \
  --limit 20
cd ../..
```

## Merchandising

```bash
cd projects/jaffle_merchandising
DBT_PROFILES_DIR=../.. mf validate-configs --skip-dw
DBT_PROFILES_DIR=../.. mf query \
  --metrics merchandising_observed_hours,merchandising_available_hours,merchandising_availability_rate,merchandising_outage_minutes \
  --group-by metric_time,product,location,product_store_hour__availability_status,product_store_hour__product_family \
  --limit 20
DBT_PROFILES_DIR=../.. mf query \
  --metrics menu_actual_units,menu_target_units,menu_unit_attainment_rate,cumulative_menu_actual_units_4w \
  --group-by metric_time,location,menu_goal__product_family,menu_goal__unit_goal_status \
  --limit 20
cd ../..
```

## Planning

```bash
cd projects/jaffle_planning
DBT_PROFILES_DIR=../.. mf validate-configs --skip-dw
DBT_PROFILES_DIR=../.. mf query \
  --metrics planned_component_usage,actual_component_usage \
  --group-by metric_time,location,component,component_week_plan__scenario_name,component_week_plan__usage_variance_status \
  --limit 20
DBT_PROFILES_DIR=../.. mf query \
  --metrics forecasted_orders,actual_orders_for_forecast,absolute_order_forecast_error,forecast_interval_hit_rate \
  --group-by metric_time,location,store_hour_forecast__scenario_name,store_hour_forecast__forecast_accuracy_band \
  --limit 20
cd ../..
```
