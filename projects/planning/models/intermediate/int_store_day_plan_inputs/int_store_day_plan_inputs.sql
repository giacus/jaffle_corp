with calendar as (
    select * from {{ ref('stg_operating_calendar') }}
),

store_hour_forecasts as (
    select
        store_id,
        forecast_date_utc,
        scenario_name,
        sum(forecasted_order_count) as forecasted_order_count,
        sum(actual_order_count) as actual_order_count,
        sum(absolute_forecast_error_orders) as absolute_forecast_error_orders,
        sum(case when actual_inside_prediction_interval then 1 else 0 end) as inside_interval_hour_count,
        count(*) as forecast_hour_count
    from {{ ref('int_store_hour_forecast_errors') }}
    group by 1, 2, 3
),

operations as (
    select
        store_id,
        operating_date,
        order_count,
        ready_target_rate,
        quality_exception_count,
        incident_count
    from {{ ref('store_ops', 'fct_store_day_operations') }}
),

pnl as (
    select
        store_id,
        recognized_date,
        net_revenue_usd,
        estimated_gross_margin_usd
    from {{ ref('finance', 'fct_daily_store_pnl') }}
)

select
    {{ shared.scenario_store_day_key("coalesce(store_hour_forecasts.scenario_name, 'base')", 'calendar.store_id', 'calendar.calendar_date_utc') }} as store_day_capacity_plan_key,
    calendar.calendar_id,
    calendar.store_id,
    calendar.calendar_date_utc,
    coalesce(store_hour_forecasts.scenario_name, 'base') as scenario_name,
    calendar.day_type,
    calendar.expected_open_minutes,
    calendar.local_holiday_name,
    calendar.menu_focus,
    coalesce(store_hour_forecasts.forecasted_order_count, 0) as forecasted_order_count,
    coalesce(store_hour_forecasts.actual_order_count, 0) as actual_order_count,
    coalesce(store_hour_forecasts.absolute_forecast_error_orders, 0) as absolute_forecast_error_orders,
    coalesce(store_hour_forecasts.inside_interval_hour_count, 0) as inside_interval_hour_count,
    coalesce(store_hour_forecasts.forecast_hour_count, 0) as forecast_hour_count,
    operations.order_count as operations_order_count,
    operations.ready_target_rate,
    operations.quality_exception_count,
    operations.incident_count,
    pnl.net_revenue_usd,
    pnl.estimated_gross_margin_usd
from calendar
left join store_hour_forecasts
    on
        calendar.store_id = store_hour_forecasts.store_id
        and calendar.calendar_date_utc = store_hour_forecasts.forecast_date_utc
left join operations
    on
        calendar.store_id = operations.store_id
        and calendar.calendar_date_utc = operations.operating_date
left join pnl
    on
        calendar.store_id = pnl.store_id
        and calendar.calendar_date_utc = pnl.recognized_date
