select
    recipe_component_key as product_component_cost_key,
    product_id,
    component_id,
    component_name,
    component_family,
    unit,
    quantity_per_item,
    waste_factor,
    average_unit_cost_usd,
    lowest_unit_cost_usd,
    highest_unit_cost_usd,
    expected_component_cost_usd,
    updated_at_utc
from {{ ref('int_recipe_component_costs') }}

