select
    cast(loyalty_event_id as varchar) as loyalty_event_id,
    cast(customer_id as varchar) as customer_id,
    cast(order_id as varchar) as order_id,
    cast(event_type as varchar) as event_type,
    cast(points_delta as integer) as points_delta,
    cast(event_at_utc as timestamp) as event_at_utc,
    cast(cast(event_at_utc as timestamp) as date) as event_date_utc,
    cast(program_tier as varchar) as program_tier,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_app', 'raw_loyalty_events') }}
