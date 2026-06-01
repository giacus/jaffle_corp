with recipe_components as (
    select * from {{ ref('stg_recipe_components') }}
),

purchase_order_costs as (
    select
        component_id,
        unit,
        avg(unit_cost_usd) as average_unit_cost_usd,
        min(unit_cost_usd) as lowest_unit_cost_usd,
        max(unit_cost_usd) as highest_unit_cost_usd
    from {{ ref('int_purchase_order_receipts') }}
    where unit_cost_usd is not null
    group by 1, 2
)

select
    recipe_components.recipe_component_key,
    recipe_components.product_id,
    recipe_components.component_id,
    recipe_components.component_name,
    recipe_components.component_family,
    recipe_components.unit,
    recipe_components.quantity_per_item,
    recipe_components.waste_factor,
    coalesce(purchase_order_costs.average_unit_cost_usd, 0) as average_unit_cost_usd,
    coalesce(purchase_order_costs.lowest_unit_cost_usd, 0) as lowest_unit_cost_usd,
    coalesce(purchase_order_costs.highest_unit_cost_usd, 0) as highest_unit_cost_usd,
    recipe_components.quantity_per_item
        * (1 + recipe_components.waste_factor)
        * coalesce(purchase_order_costs.average_unit_cost_usd, 0) as expected_component_cost_usd,
    recipe_components.updated_at_utc
from recipe_components
left join purchase_order_costs
    on recipe_components.component_id = purchase_order_costs.component_id
    and recipe_components.unit = purchase_order_costs.unit

