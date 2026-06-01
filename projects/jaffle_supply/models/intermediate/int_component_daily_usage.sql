with order_items as (
    select * from {{ ref('jaffle_platform', 'fct_order_items') }}
),

orders as (
    select
        order_id,
        store_id,
        is_completed_order
    from {{ ref('jaffle_platform', 'fct_orders') }}
),

recipe_components as (
    select * from {{ ref('stg_recipe_components') }}
)

select
    orders.store_id,
    order_items.ordered_date_utc as usage_date_utc,
    recipe_components.component_id,
    recipe_components.unit,
    cast(sum(order_items.quantity * recipe_components.quantity_per_item) as double) as expected_used_quantity,
    cast(sum(order_items.quantity * recipe_components.quantity_per_item * recipe_components.waste_factor) as double)
        as expected_recipe_waste_quantity,
    cast(count(distinct order_items.order_id) as integer) as order_count_using_component,
    cast(sum(order_items.quantity) as integer) as item_quantity_using_component
from order_items
inner join orders on order_items.order_id = orders.order_id
inner join recipe_components on order_items.product_id = recipe_components.product_id
where orders.is_completed_order
group by 1, 2, 3, 4

