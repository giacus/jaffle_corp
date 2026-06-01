with exposures as (
    select * from {{ ref('stg_experiment_exposures') }}
),

orders as (
    select
        order_id,
        customer_id,
        ordered_at_utc,
        ordered_date_utc,
        channel,
        is_completed_order
    from {{ ref('jaffle_platform', 'fct_orders') }}
),

revenue as (
    select
        order_id,
        net_revenue_usd,
        estimated_gross_margin_usd
    from {{ ref('jaffle_finance', 'fct_order_revenue') }}
),

exposure_orders as (
    select
        exposures.exposure_id,
        orders.order_id,
        orders.ordered_at_utc,
        orders.channel,
        orders.is_completed_order,
        revenue.net_revenue_usd,
        revenue.estimated_gross_margin_usd
    from exposures
    left join orders
        on exposures.customer_id = orders.customer_id
        and orders.ordered_at_utc >= exposures.exposed_at_utc
        and orders.ordered_at_utc < exposures.exposed_at_utc + interval '7 days'
    left join revenue on orders.order_id = revenue.order_id
)

select
    exposures.exposure_id,
    exposures.customer_id,
    exposures.experiment_id,
    exposures.variant_id,
    exposures.exposed_at_utc,
    exposures.exposed_date_utc,
    exposures.surface,
    exposures.assignment_reason,
    cast(count(distinct exposure_orders.order_id) as integer) as order_count_7d,
    cast(sum(case when exposure_orders.is_completed_order then 1 else 0 end) as integer) as completed_order_count_7d,
    min(exposure_orders.ordered_at_utc) as first_ordered_at_utc_after_exposure,
    sum(coalesce(exposure_orders.net_revenue_usd, 0)) as net_revenue_usd_7d,
    sum(coalesce(exposure_orders.estimated_gross_margin_usd, 0)) as estimated_margin_usd_7d,
    exposures.updated_at_utc
from exposures
left join exposure_orders on exposures.exposure_id = exposure_orders.exposure_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 14

