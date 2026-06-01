with promo_events as (
    select * from {{ ref('jaffle_platform', 'fct_promo_events') }}
),

orders as (
    select
        order_id,
        customer_id,
        order_status,
        is_completed_order,
        order_total_major,
        order_total_usd
    from {{ ref('jaffle_platform', 'fct_orders') }}
),

revenue as (
    select
        order_id,
        net_revenue_usd,
        estimated_gross_margin_usd
    from {{ ref('jaffle_finance', 'fct_order_revenue') }}
)

select
    promo_events.promo_event_id,
    promo_events.customer_id,
    promo_events.order_id,
    promo_events.campaign_id,
    promo_events.event_type,
    promo_events.event_at_utc,
    promo_events.event_date_utc,
    promo_events.channel,
    promo_events.cost_major,
    promo_events.currency,
    case
        when orders.order_total_major = 0 or orders.order_total_major is null then promo_events.cost_major
        else promo_events.cost_major * (orders.order_total_usd / orders.order_total_major)
    end as estimated_cost_usd,
    coalesce(orders.is_completed_order, false) as is_completed_order,
    revenue.net_revenue_usd,
    revenue.estimated_gross_margin_usd,
    promo_events.event_type = 'redeemed' and orders.is_completed_order as is_attributed_order
from promo_events
left join orders on promo_events.order_id = orders.order_id
left join revenue on promo_events.order_id = revenue.order_id

