with items as (
    select * from {{ ref('jaffle_platform', 'fct_order_items') }}
),

orders as (
    select
        order_id,
        ordered_date_utc,
        country_code,
        currency,
        case
            when order_total_major = 0 then 0
            else order_total_usd / order_total_major
        end as usd_per_order_currency_unit
    from {{ ref('jaffle_platform', 'fct_orders') }}
)

select
    items.order_item_id,
    items.order_id,
    orders.ordered_date_utc,
    items.product_id,
    items.product_family,
    items.category,
    orders.country_code,
    orders.currency as order_currency,
    items.supply_currency,
    items.quantity,
    items.item_total_major,
    items.estimated_supply_cost_minor,
    {{ jaffle_shared.minor_units_to_major_units('items.estimated_supply_cost_minor') }}
        as estimated_supply_cost_major,
    {{ jaffle_shared.minor_units_to_major_units('items.estimated_supply_cost_minor') }}
        * orders.usd_per_order_currency_unit as estimated_supply_cost_usd
from items
left join orders on items.order_id = orders.order_id

