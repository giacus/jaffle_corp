select
    {{ jaffle_shared.stable_hash(['loyalty_event_id', 'event_at_utc']) }} as loyalty_event_key,
    loyalty_event_id,
    customer_id,
    order_id,
    event_type,
    points_delta,
    event_at_utc,
    event_date_utc,
    program_tier,
    updated_at_utc
from {{ ref('stg_loyalty_events') }}
