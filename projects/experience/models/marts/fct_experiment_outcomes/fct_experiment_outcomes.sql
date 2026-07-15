select
    {{ jaffle_shared.stable_hash(['exposure_id']) }} as experiment_outcome_key,
    exposure_id,
    customer_id,
    experiment_id,
    variant_id,
    exposed_at_utc,
    exposed_date_utc,
    surface,
    assignment_reason,
    order_count_7d,
    completed_order_count_7d,
    first_ordered_at_utc_after_exposure,
    net_revenue_usd_7d,
    estimated_margin_usd_7d,
    completed_order_count_7d > 0 as converted_7d,
    updated_at_utc
from {{ ref('int_experiment_order_outcomes') }}
