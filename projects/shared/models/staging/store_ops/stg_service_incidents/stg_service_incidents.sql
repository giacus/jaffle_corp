select
    cast(incident_id as varchar) as incident_id,
    cast(store_id as varchar) as store_id,
    cast(opened_at_utc as timestamp) as opened_at_utc,
    cast(resolved_at_utc as timestamp) as resolved_at_utc,
    cast(cast(opened_at_utc as timestamp) as date) as opened_date_utc,
    cast(incident_type as varchar) as incident_type,
    lower(cast(severity as varchar)) as severity,
    cast(affected_orders as integer) as affected_orders,
    cast(notes_code as varchar) as notes_code,
    {{ shared.minutes_between('opened_at_utc', 'resolved_at_utc') }} as incident_minutes,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('store_ops_app', 'raw_service_incidents') }}
