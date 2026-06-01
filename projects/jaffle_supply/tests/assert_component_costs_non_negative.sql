select *
from {{ ref('fct_product_component_costs') }}
where expected_component_cost_usd < 0
    or average_unit_cost_usd < 0

