{{ config(tags=['forecast_accuracy']) }}

select
    store_hour_forecast_accuracy_key,
    forecast_id,
    model_run_id,
    store_id,
    forecast_hour_utc,
    forecast_date_utc,
    forecasted_order_count,
    lower_bound_orders,
    upper_bound_orders,
    scenario_name,
    model_version,
    actual_order_count,
    actual_completed_order_count,
    actual_order_total_usd,
    average_received_to_ready_minutes,
    ready_inside_target_count,
    forecast_error_orders,
    absolute_forecast_error_orders,
    absolute_percentage_error_orders,
    {{ shared.forecast_accuracy_band('absolute_percentage_error_orders') }} as forecast_accuracy_band,
    actual_inside_prediction_interval,
    created_at_utc,
    updated_at_utc
from {{ ref('int_store_hour_forecast_errors') }}
