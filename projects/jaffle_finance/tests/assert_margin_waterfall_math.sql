select *
from {{ ref('fct_order_margin_waterfall') }}
where abs((net_revenue_usd - recipe_expected_component_cost_usd) - recipe_margin_usd) > 0.01

