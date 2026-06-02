select
    {{ jaffle_shared.stable_hash(['customer_id', 'event_date_utc']) }} as loyalty_balance_daily_key,
    customer_id,
    event_date_utc,
    points_delta,
    projected_points_balance,
    latest_program_tier,
    loyalty_event_count,
    loyalty_balance_status
from {{ ref('int_loyalty_balance_projection') }}
