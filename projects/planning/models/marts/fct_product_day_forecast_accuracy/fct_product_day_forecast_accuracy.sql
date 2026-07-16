{{ config(tags=['forecast_accuracy']) }}

select
    product_day_forecast_accuracy_key,
    forecast_id,
    model_run_id,
    store_id,
    product_id,
    product_family,
    category,
    forecast_date_utc,
    forecasted_units,
    planned_price_minor,
    scenario_name,
    model_version,
    actual_units,
    actual_item_revenue_usd,
    actual_order_count,
    forecast_error_units,
    absolute_forecast_error_units,
    absolute_percentage_error_units,
    {{ shared.forecast_accuracy_band('absolute_percentage_error_units') }} as forecast_accuracy_band,
    created_at_utc,
    updated_at_utc
from {{ ref('int_product_day_forecast_errors') }}
