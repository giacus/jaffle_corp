select
    {{ shared.stable_hash(['experiment_id', 'variant_id', 'exposed_date_utc', 'surface']) }}
        as experiment_conversion_key,
    experiment_id,
    variant_id,
    exposed_date_utc,
    surface,
    exposure_count,
    conversion_count,
    order_count_7d,
    net_revenue_usd_7d,
    estimated_margin_usd_7d,
    conversion_rate
from {{ ref('int_experiment_conversion_rollup') }}
