select
    recognized_date,
    country_code,
    sum(net_revenue_usd) as net_revenue_usd,
    sum(platform_margin_usd) as platform_margin_usd,
    sum(recipe_margin_usd) as recipe_margin_usd,
    sum(recipe_cost_variance_usd) as recipe_cost_variance_usd
from {{ ref('fct_order_margin_waterfall') }}
group by 1, 2
order by 1, 2
