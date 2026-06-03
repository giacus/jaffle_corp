with customers as (
    select * from {{ ref('jaffle_platform', 'dim_customers') }}
),

orders as (
    select * from {{ ref('jaffle_platform', 'fct_orders') }}
),

revenue as (
    select * from {{ ref('jaffle_finance', 'fct_order_revenue') }}
),

loyalty as (
    select
        customer_id,
        cast(sum(points_delta) as integer) as net_loyalty_points,
        max(program_tier) as latest_program_tier
    from {{ ref('jaffle_platform', 'fct_loyalty_events') }}
    group by 1
),

customer_revenue as (
    select
        orders.customer_id,
        min(orders.ordered_at_utc) as first_ordered_at_utc,
        max(orders.ordered_at_utc) as most_recent_ordered_at_utc,
        cast(count(*) as integer) as order_count,
        cast(sum(case when orders.is_completed_order then 1 else 0 end) as integer)
            as completed_order_count,
        sum(coalesce(revenue.net_revenue_usd, 0)) as lifetime_net_revenue_usd,
        sum(coalesce(revenue.estimated_gross_margin_usd, 0)) as lifetime_margin_usd
    from orders
    left join revenue on orders.order_id = revenue.order_id
    group by 1
)

select
    customers.customer_id,
    customers.customer_name,
    customers.email_domain,
    customers.loyalty_region,
    customers.first_seen_at,
    customers.default_currency,
    customers.marketing_consent,
    customer_revenue.first_ordered_at_utc,
    customer_revenue.most_recent_ordered_at_utc,
    coalesce(customer_revenue.order_count, 0) as order_count,
    coalesce(customer_revenue.completed_order_count, 0) as completed_order_count,
    coalesce(customer_revenue.lifetime_net_revenue_usd, 0) as lifetime_net_revenue_usd,
    coalesce(customer_revenue.lifetime_margin_usd, 0) as lifetime_margin_usd,
    coalesce(loyalty.net_loyalty_points, 0) as net_loyalty_points,
    coalesce(loyalty.latest_program_tier, 'unassigned') as latest_program_tier,
    case
        when coalesce(customer_revenue.completed_order_count, 0) >= 2 then 'repeat'
        when coalesce(customer_revenue.completed_order_count, 0) = 1 then 'activated'
        when customers.marketing_consent then 'marketable'
        else 'prospect'
    end as lifecycle_stage
from customers
left join customer_revenue on customers.customer_id = customer_revenue.customer_id
left join loyalty on customers.customer_id = loyalty.customer_id
