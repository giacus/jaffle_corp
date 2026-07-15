select
    value_band,
    care_profile,
    count(*) as customer_count,
    sum(lifetime_net_revenue_usd) as lifetime_net_revenue_usd,
    sum(lifetime_recipe_margin_usd) as lifetime_recipe_margin_usd
from {{ ref('fct_customer_value_segments') }}
group by 1, 2
order by 1, 2
