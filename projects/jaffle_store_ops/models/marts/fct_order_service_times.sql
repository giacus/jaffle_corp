select
    {{ jaffle_shared.stable_hash(['order_id', 'store_id']) }} as order_service_time_key,
    order_id,
    store_id,
    customer_id,
    ordered_at_utc,
    ordered_date_utc,
    order_status,
    is_completed_order,
    kitchen_received_at_utc,
    prep_started_at_utc,
    ready_at_utc,
    served_at_utc,
    event_date_utc,
    stations_seen,
    kitchen_event_count,
    received_to_ready_minutes,
    prep_to_ready_minutes,
    ready_to_served_minutes,
    {{ jaffle_shared.bucket_minutes('received_to_ready_minutes') }} as received_to_ready_bucket,
    received_to_ready_minutes <= {{ var('kitchen_ready_target_minutes', 12) }} as met_ready_target
from {{ ref('int_order_kitchen_timing') }}

