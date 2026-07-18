with revenue_quality as (
    select
        store_id,
        recognized_date,
        order_count,
        net_revenue_usd,
        recipe_margin_rate,
        refund_order_rate,
        revenue_exception_rate,
        store_day_revenue_quality_status
    from {{ ref('finance', 'fct_store_day_revenue_quality') }}
),

availability as (
    select
        store_id,
        available_date_utc,
        cast(count(distinct product_id) as integer) as observed_product_count,
        cast(sum(observed_hour_count) as integer) as observed_hour_count,
        cast(sum(available_hour_count) as integer) as available_hour_count,
        cast(sum(constrained_hour_count) as integer) as constrained_hour_count,
        cast(sum(unavailable_hour_count) as integer) as unavailable_hour_count,
        cast(sum(outage_minutes) as integer) as outage_minutes,
        avg(availability_rate) as average_product_availability_rate
    from {{ ref('merchandising', 'fct_product_store_day_availability') }}
    group by 1, 2
),

capacity_plan as (
    select
        store_id,
        calendar_date_utc,
        scenario_name,
        forecasted_order_count,
        cast(actual_order_count as integer) as actual_order_count,
        prediction_interval_hit_rate,
        ready_target_rate
    from {{ ref('planning', 'fct_store_day_capacity_plan') }}
    where scenario_name = 'base'
),

scored as (
    select
        {{ shared.scenario_store_day_key("'base'", 'revenue_quality.store_id', 'revenue_quality.recognized_date') }} as store_day_reliability_key,
        revenue_quality.store_id,
        revenue_quality.recognized_date as reliability_date,
        coalesce(capacity_plan.scenario_name, 'base') as scenario_name,
        revenue_quality.order_count,
        revenue_quality.net_revenue_usd,
        revenue_quality.recipe_margin_rate,
        revenue_quality.refund_order_rate,
        revenue_quality.revenue_exception_rate,
        revenue_quality.store_day_revenue_quality_status,
        coalesce(availability.observed_product_count, 0) as observed_product_count,
        coalesce(availability.observed_hour_count, 0) as observed_hour_count,
        coalesce(availability.available_hour_count, 0) as available_hour_count,
        coalesce(availability.constrained_hour_count, 0) as constrained_hour_count,
        coalesce(availability.unavailable_hour_count, 0) as unavailable_hour_count,
        coalesce(availability.outage_minutes, 0) as outage_minutes,
        availability.average_product_availability_rate,
        capacity_plan.forecasted_order_count,
        capacity_plan.actual_order_count,
        capacity_plan.prediction_interval_hit_rate,
        capacity_plan.ready_target_rate,
        greatest(0.0, least(
            1.0,
            0.45 * coalesce(availability.average_product_availability_rate, 1.0)
            + 0.25 * coalesce(capacity_plan.prediction_interval_hit_rate, 1.0)
            + 0.20 * coalesce(capacity_plan.ready_target_rate, 1.0)
            + 0.10 * (1.0 - coalesce(revenue_quality.revenue_exception_rate, 0.0))
        )) as reliability_score
    from revenue_quality
    left join availability
        on
            revenue_quality.store_id = availability.store_id
            and revenue_quality.recognized_date = availability.available_date_utc
    left join capacity_plan
        on
            revenue_quality.store_id = capacity_plan.store_id
            and revenue_quality.recognized_date = capacity_plan.calendar_date_utc
)

select
    store_day_reliability_key,
    store_id,
    reliability_date,
    scenario_name,
    order_count,
    net_revenue_usd,
    recipe_margin_rate,
    refund_order_rate,
    revenue_exception_rate,
    store_day_revenue_quality_status,
    observed_product_count,
    observed_hour_count,
    available_hour_count,
    constrained_hour_count,
    unavailable_hour_count,
    outage_minutes,
    average_product_availability_rate,
    case
        when average_product_availability_rate is null then 'unobserved'
        when average_product_availability_rate < 0.75 then 'availability_risk'
        when average_product_availability_rate < 0.90 then 'availability_watch'
        else 'availability_stable'
    end as product_availability_status,
    forecasted_order_count,
    actual_order_count,
    prediction_interval_hit_rate,
    ready_target_rate,
    reliability_score,
    {{ function('reliability_status') }}(reliability_score) as reliability_status,
    reliability_score < 0.80 as needs_reliability_review
from scored
