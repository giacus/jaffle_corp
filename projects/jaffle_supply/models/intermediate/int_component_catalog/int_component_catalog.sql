with recipe_components as (
    select * from {{ ref('stg_recipe_components') }}
),

purchase_orders as (
    select * from {{ ref('stg_purchase_orders') }}
)

select
    recipe_components.component_id,
    min(recipe_components.component_name) as component_name,
    min(recipe_components.component_family) as component_family,
    min(recipe_components.unit) as recipe_unit,
    cast(count(distinct recipe_components.product_id) as integer) as product_count,
    min(recipe_components.waste_factor) as minimum_recipe_waste_factor,
    max(recipe_components.waste_factor) as maximum_recipe_waste_factor,
    cast(count(distinct purchase_orders.supplier_name) as integer) as supplier_count,
    min(purchase_orders.supplier_name) as primary_supplier_name,
    max(recipe_components.updated_at_utc) as updated_at_utc
from recipe_components
left join purchase_orders
    on recipe_components.component_id = purchase_orders.component_id
group by 1
