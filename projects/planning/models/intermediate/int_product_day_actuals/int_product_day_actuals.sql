select
    orders.store_id,
    items.product_id,
    orders.ordered_date_utc as actual_date_utc,
    cast(sum(items.quantity) as integer) as actual_units,
    sum(items.item_total_major) as actual_item_revenue_usd,
    cast(count(distinct orders.order_id) as integer) as actual_order_count
from {{ ref('jaffle_platform', 'fct_order_items') }} as items
inner join {{ ref('jaffle_platform', 'fct_orders') }} as orders
    on items.order_id = orders.order_id
where orders.is_completed_order
group by 1, 2, 3
