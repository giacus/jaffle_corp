select
    {{ shared.stable_hash(['store_id', 'recognized_date']) }} as store_day_revenue_quality_key,
    store_id,
    recognized_date,
    country_code,
    city,
    order_count,
    net_revenue_usd,
    recipe_margin_usd,
    recipe_cost_variance_usd,
    refund_order_count,
    revenue_exception_order_count,
    negative_margin_order_count,
    recipe_margin_rate,
    refund_order_rate,
    revenue_exception_rate,
    store_day_revenue_quality_status
from {{ ref('int_store_day_revenue_quality') }}
