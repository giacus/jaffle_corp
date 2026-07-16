select
    {{ shared.stable_hash(['order_item_id', 'product_id']) }} as component_cost_variance_key,
    order_item_id,
    order_id,
    product_id,
    ordered_date_utc,
    quantity,
    platform_estimated_supply_cost_major,
    recipe_expected_component_cost_usd,
    recipe_expected_component_cost_usd - platform_estimated_supply_cost_major as component_cost_variance_usd,
    component_count,
    component_families
from {{ ref('int_order_component_cost_bridge') }}
