select
    cast(forecast_id as varchar) as forecast_id,
    cast(model_run_id as varchar) as model_run_id,
    cast(store_id as varchar) as store_id,
    cast(forecast_hour_utc as timestamp) as forecast_hour_utc,
    cast(forecasted_order_count as double) as forecasted_order_count,
    cast(lower_bound_orders as double) as lower_bound_orders,
    cast(upper_bound_orders as double) as upper_bound_orders,
    cast(scenario_name as varchar) as scenario_name,
    cast(model_version as varchar) as model_version,
    cast(created_at_utc as timestamp) as created_at_utc,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('planning_app', 'raw_store_hour_forecasts') }}
