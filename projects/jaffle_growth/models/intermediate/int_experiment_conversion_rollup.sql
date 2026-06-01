select
    experiment_id,
    variant_id,
    exposed_date_utc,
    surface,
    count(*) as exposure_count,
    sum(case when converted_7d then 1 else 0 end) as conversion_count,
    sum(order_count_7d) as order_count_7d,
    sum(net_revenue_usd_7d) as net_revenue_usd_7d,
    sum(estimated_margin_usd_7d) as estimated_margin_usd_7d,
    {{ jaffle_shared.safe_divide(
        'sum(case when converted_7d then 1 else 0 end)',
        'count(*)'
    ) }} as conversion_rate
from {{ ref('jaffle_experience', 'fct_experiment_outcomes') }}
group by 1, 2, 3, 4

