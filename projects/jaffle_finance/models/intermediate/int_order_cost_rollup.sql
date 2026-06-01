select
    order_id,
    cast(count(*) as integer) as order_item_count,
    cast(sum(quantity) as integer) as total_item_quantity,
    sum(item_total_major) as item_sales_major,
    sum(estimated_supply_cost_usd) as estimated_supply_cost_usd
from {{ ref('int_order_item_costs') }}
group by 1
