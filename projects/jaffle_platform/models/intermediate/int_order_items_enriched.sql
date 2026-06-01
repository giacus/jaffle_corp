with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

orders as (
    select
        order_id,
        ordered_date_utc
    from {{ ref('stg_orders') }}
),

supplies as (
    select
        product_id,
        min(unit_cost_minor) as unit_cost_minor,
        min(currency) as supply_currency,
        bool_or(perishable) as has_perishable_supply,
        max(lead_time_days) as max_lead_time_days
    from {{ ref('stg_supplies') }}
    group by 1
)

select
    order_items.order_item_id,
    order_items.order_id,
    orders.ordered_date_utc,
    order_items.product_id,
    products.sku,
    products.product_name,
    products.category,
    products.product_family,
    order_items.quantity,
    order_items.item_subtotal_minor,
    order_items.item_discount_minor,
    order_items.item_tax_minor,
    order_items.item_total_minor,
    order_items.item_total_major,
    order_items.customization_count,
    supplies.unit_cost_minor,
    supplies.supply_currency,
    supplies.has_perishable_supply,
    supplies.max_lead_time_days,
    coalesce(supplies.unit_cost_minor, 0) * order_items.quantity as estimated_supply_cost_minor
from order_items
left join orders on order_items.order_id = orders.order_id
left join products on order_items.product_id = products.product_id
left join supplies on order_items.product_id = supplies.product_id
