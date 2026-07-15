select
    customer_id,
    min(ordered_at_utc) as first_ordered_at_utc,
    max(ordered_at_utc) as most_recent_ordered_at_utc,
    cast(count(*) as integer) as lifetime_order_count,
    cast(sum(case when is_completed_order then 1 else 0 end) as integer)
        as lifetime_completed_order_count,
    sum(order_total_usd) as lifetime_order_value_usd,
    cast(sum(case when refund_event_count > 0 then 1 else 0 end) as integer)
        as lifetime_refunded_order_count
from {{ ref('int_orders_enriched') }}
group by 1
