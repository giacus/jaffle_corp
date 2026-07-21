select
    reliability.store_id,
    reliability.reliability_date,
    reliability.reliability_status,
    {{ function('current_store_reliability') }}(
        reliability.store_id,
        reliability.reliability_date
    ) as current_store_reliability_status,
    reliability.product_availability_status,
    reliability.net_revenue_usd,
    reliability.average_product_availability_rate,
    reliability.prediction_interval_hit_rate,
    reliability.reliability_score
from {{ ref('fct_store_day_reliability') }} as reliability
order by
    reliability.reliability_score,
    reliability.reliability_date,
    reliability.store_id
