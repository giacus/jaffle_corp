select
    {{ jaffle_shared.stable_hash(['product_id', 'component_id']) }} as recipe_component_key,
    cast(product_id as varchar) as product_id,
    cast(component_id as varchar) as component_id,
    cast(component_name as varchar) as component_name,
    cast(component_family as varchar) as component_family,
    cast(unit as varchar) as unit,
    cast(quantity_per_item as double) as quantity_per_item,
    cast(waste_factor as double) as waste_factor,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_supply_app', 'raw_recipe_components') }}

