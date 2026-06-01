with store_hour as (
    select
        store_id,
        forecast_date_utc as exception_date_utc,
        scenario_name,
        'store_hour_forecast' as exception_family,
        sum(case when absolute_percentage_error_orders > {{ var('planning_accuracy_tolerance', 0.25) }} then 1 else 0 end) as exception_count
    from {{ ref('int_store_hour_forecast_errors') }}
    group by 1, 2, 3, 4
),

product_day as (
    select
        store_id,
        forecast_date_utc as exception_date_utc,
        scenario_name,
        'product_day_forecast' as exception_family,
        sum(case when absolute_percentage_error_units > {{ var('planning_accuracy_tolerance', 0.25) }} then 1 else 0 end) as exception_count
    from {{ ref('int_product_day_forecast_errors') }}
    group by 1, 2, 3, 4
),

component_week as (
    select
        store_id,
        plan_week_start_utc as exception_date_utc,
        scenario_name,
        'component_week_plan' as exception_family,
        sum(case when usage_variance_status != 'inside_tolerance' then 1 else 0 end) as exception_count
    from {{ ref('int_component_week_plan_actuals') }}
    group by 1, 2, 3, 4
)

select * from store_hour
union all
select * from product_day
union all
select * from component_week
