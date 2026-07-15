with forecasts as (
    select * from {{ ref('stg_product_day_forecasts') }}
),

actuals as (
    select * from {{ ref('int_product_day_actuals') }}
),

products as (
    select
        product_id,
        product_family,
        category
    from {{ ref('jaffle_platform', 'dim_products') }}
)

select
    {{ jaffle_shared.scenario_product_store_day_key('forecasts.scenario_name', 'forecasts.product_id', 'forecasts.store_id', 'forecasts.forecast_date_utc') }} as product_day_forecast_accuracy_key,
    forecasts.forecast_id,
    forecasts.model_run_id,
    forecasts.store_id,
    forecasts.product_id,
    products.product_family,
    products.category,
    forecasts.forecast_date_utc,
    forecasts.forecasted_units,
    forecasts.planned_price_minor,
    forecasts.scenario_name,
    forecasts.model_version,
    coalesce(actuals.actual_units, 0) as actual_units,
    coalesce(actuals.actual_item_revenue_usd, 0) as actual_item_revenue_usd,
    coalesce(actuals.actual_order_count, 0) as actual_order_count,
    {{ jaffle_shared.forecast_error('coalesce(actuals.actual_units, 0)', 'forecasts.forecasted_units') }} as forecast_error_units,
    {{ jaffle_shared.absolute_forecast_error('coalesce(actuals.actual_units, 0)', 'forecasts.forecasted_units') }} as absolute_forecast_error_units,
    {{ jaffle_shared.safe_divide(jaffle_shared.absolute_forecast_error('coalesce(actuals.actual_units, 0)', 'forecasts.forecasted_units'), 'nullif(actuals.actual_units, 0)') }} as absolute_percentage_error_units,
    forecasts.created_at_utc,
    forecasts.updated_at_utc
from forecasts
left join actuals
    on
        forecasts.store_id = actuals.store_id
        and forecasts.product_id = actuals.product_id
        and forecasts.forecast_date_utc = actuals.actual_date_utc
left join products on forecasts.product_id = products.product_id
