with forecasts as (
    select * from {{ ref('stg_store_hour_forecasts') }}
),

actuals as (
    select * from {{ ref('int_store_hour_actuals') }}
)

select
    {{ jaffle_shared.stable_hash(['forecasts.forecast_id', 'forecasts.store_id', 'forecasts.forecast_hour_utc']) }} as store_hour_forecast_accuracy_key,
    forecasts.forecast_id,
    forecasts.model_run_id,
    forecasts.store_id,
    forecasts.forecast_hour_utc,
    cast(forecasts.forecast_hour_utc as date) as forecast_date_utc,
    forecasts.forecasted_order_count,
    forecasts.lower_bound_orders,
    forecasts.upper_bound_orders,
    forecasts.scenario_name,
    forecasts.model_version,
    coalesce(actuals.actual_order_count, 0) as actual_order_count,
    coalesce(actuals.actual_completed_order_count, 0) as actual_completed_order_count,
    coalesce(actuals.actual_order_total_usd, 0) as actual_order_total_usd,
    actuals.average_received_to_ready_minutes,
    actuals.ready_inside_target_count,
    {{ jaffle_shared.forecast_error('coalesce(actuals.actual_order_count, 0)', 'forecasts.forecasted_order_count') }} as forecast_error_orders,
    {{ jaffle_shared.absolute_forecast_error('coalesce(actuals.actual_order_count, 0)', 'forecasts.forecasted_order_count') }} as absolute_forecast_error_orders,
    {{ jaffle_shared.safe_divide(jaffle_shared.absolute_forecast_error('coalesce(actuals.actual_order_count, 0)', 'forecasts.forecasted_order_count'), 'nullif(actuals.actual_order_count, 0)') }} as absolute_percentage_error_orders,
    case
        when coalesce(actuals.actual_order_count, 0) between forecasts.lower_bound_orders and forecasts.upper_bound_orders then true
        else false
    end as actual_inside_prediction_interval,
    forecasts.created_at_utc,
    forecasts.updated_at_utc
from forecasts
left join actuals
    on forecasts.store_id = actuals.store_id
    and forecasts.forecast_hour_utc = actuals.actual_hour_utc
