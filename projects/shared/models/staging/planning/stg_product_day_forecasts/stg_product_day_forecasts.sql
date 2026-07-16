select
    cast(forecast_id as varchar) as forecast_id,
    cast(model_run_id as varchar) as model_run_id,
    cast(store_id as varchar) as store_id,
    cast(product_id as varchar) as product_id,
    cast(forecast_date_utc as date) as forecast_date_utc,
    cast(forecasted_units as double) as forecasted_units,
    cast(planned_price_minor as integer) as planned_price_minor,
    cast(scenario_name as varchar) as scenario_name,
    cast(model_version as varchar) as model_version,
    cast(created_at_utc as timestamp) as created_at_utc,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('planning_app', 'raw_product_day_forecasts') }}
