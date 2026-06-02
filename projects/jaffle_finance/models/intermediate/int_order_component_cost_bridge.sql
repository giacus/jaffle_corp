with order_items as (
    select * from {{ ref('jaffle_platform', 'fct_order_items') }}
),

component_costs as (
    select * from {{ ref('jaffle_supply', 'fct_product_component_costs') }}
)

select
    order_items.order_item_id,
    order_items.order_id,
    order_items.product_id,
    order_items.ordered_date_utc,
    order_items.quantity,
    order_items.estimated_supply_cost_minor,
    {{ jaffle_shared.minor_units_to_major_units('order_items.estimated_supply_cost_minor') }}
        as platform_estimated_supply_cost_major,
    sum(component_costs.expected_component_cost_usd * order_items.quantity) as recipe_expected_component_cost_usd,
    count(distinct component_costs.component_id) as component_count,
    string_agg(distinct component_costs.component_family, ', ' order by component_costs.component_family)
        as component_families
from order_items
left join component_costs on order_items.product_id = component_costs.product_id
group by 1, 2, 3, 4, 5, 6, 7
