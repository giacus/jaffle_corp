select
    {{ jaffle_shared.stable_hash(['support_ticket_id']) }} as contact_thread_key,
    support_ticket_id,
    min(first_contact_at_utc) as first_contact_at_utc,
    max(most_recent_contact_at_utc) as most_recent_contact_at_utc,
    max(contact_event_count) as contact_event_count,
    max(total_message_count) as total_message_count,
    max(inbound_contact_count) as inbound_contact_count,
    max(outbound_contact_count) as outbound_contact_count,
    string_agg(distinct contact_channel, ', ' order by contact_channel) as contact_channels,
    string_agg(distinct handled_by_role, ', ' order by handled_by_role) as handling_roles,
    max(updated_at_utc) as updated_at_utc
from {{ ref('int_customer_contact_sequences') }}
group by 1, 2
