select
    {{ shared.stable_hash(['promo_event_id', 'event_at_utc']) }} as promo_event_key,
    promo_event_id,
    customer_id,
    order_id,
    campaign_id,
    event_type,
    event_at_utc,
    event_date_utc,
    channel,
    cost_minor,
    cost_major,
    currency,
    updated_at_utc
from {{ ref('stg_promo_events') }}
