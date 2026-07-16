select
    cast(contact_event_id as varchar) as contact_event_id,
    cast(support_ticket_id as varchar) as support_ticket_id,
    cast(contact_channel as varchar) as contact_channel,
    lower(cast(contact_direction as varchar)) as contact_direction,
    cast(contact_at_utc as timestamp) as contact_at_utc,
    cast(message_count as integer) as message_count,
    cast(handled_by_role as varchar) as handled_by_role,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('experience_app', 'raw_customer_contacts') }}
