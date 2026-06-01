select
    component_id,
    component_name,
    component_family,
    recipe_unit,
    product_count,
    minimum_recipe_waste_factor,
    maximum_recipe_waste_factor,
    supplier_count,
    primary_supplier_name,
    updated_at_utc
from {{ ref('int_component_catalog') }}

