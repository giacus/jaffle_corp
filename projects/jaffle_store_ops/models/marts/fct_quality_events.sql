select
    {{ jaffle_shared.stable_hash(['quality_check_id']) }} as quality_event_key,
    quality_check_id,
    store_id,
    order_id,
    product_id,
    check_type,
    check_result,
    measured_value,
    expected_min,
    expected_max,
    checked_at_utc,
    checked_date_utc,
    measured_value < expected_min or measured_value > expected_max or check_result <> 'pass' as has_quality_exception,
    updated_at_utc
from {{ ref('stg_quality_checks') }}

