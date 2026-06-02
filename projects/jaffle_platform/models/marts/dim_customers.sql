with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('int_customer_order_rollup') }}
)

select
    customers.customer_id,
    customers.customer_name,
    customers.email_domain,
    customers.loyalty_region,
    customers.first_seen_at,
    customers.default_currency,
    customers.marketing_consent,
    orders.first_ordered_at_utc,
    orders.most_recent_ordered_at_utc,
    coalesce(orders.lifetime_order_count, 0) as lifetime_order_count,
    coalesce(orders.lifetime_completed_order_count, 0) as lifetime_completed_order_count,
    coalesce(orders.lifetime_order_value_usd, 0) as lifetime_order_value_usd,
    coalesce(orders.lifetime_refunded_order_count, 0) as lifetime_refunded_order_count,
    case
        when coalesce(orders.lifetime_completed_order_count, 0) >= 2 then 'repeat'
        when coalesce(orders.lifetime_completed_order_count, 0) = 1 then 'activated'
        else 'new'
    end as lifecycle_stage
from customers
left join orders on customers.customer_id = orders.customer_id
