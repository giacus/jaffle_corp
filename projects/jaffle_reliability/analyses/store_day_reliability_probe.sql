select
    store_id,
    reliability_date,
    reliability_status,
    product_availability_status,
    net_revenue_usd,
    average_product_availability_rate,
    prediction_interval_hit_rate,
    reliability_score
from {{ ref('fct_store_day_reliability') }}
order by reliability_score, reliability_date, store_id
