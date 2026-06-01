select
    cast(kitchen_event_id as varchar) as kitchen_event_id,
    cast(order_id as varchar) as order_id,
    cast(store_id as varchar) as store_id,
    cast(station as varchar) as station,
    {{ jaffle_shared.normalize_event_type('event_type') }} as kitchen_event_type,
    cast(event_type as varchar) as raw_event_type,
    cast(event_at_utc as timestamp) as event_at_utc,
    cast(cast(event_at_utc as timestamp) as date) as event_date_utc,
    cast(batch_id as varchar) as batch_id,
    cast(operator_initials as varchar) as operator_initials,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_store_ops_app', 'raw_kitchen_events') }}

