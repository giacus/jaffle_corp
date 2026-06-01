with contacts as (
    select * from {{ ref('stg_customer_contacts') }}
),

ticket_bounds as (
    select
        support_ticket_id,
        min(contact_at_utc) as first_contact_at_utc,
        max(contact_at_utc) as most_recent_contact_at_utc,
        cast(count(*) as integer) as contact_event_count,
        cast(sum(message_count) as integer) as total_message_count,
        cast(sum(case when contact_direction = 'inbound' then 1 else 0 end) as integer) as inbound_contact_count,
        cast(sum(case when contact_direction = 'outbound' then 1 else 0 end) as integer) as outbound_contact_count
    from contacts
    group by 1
)

select
    contacts.contact_event_id,
    contacts.support_ticket_id,
    contacts.contact_channel,
    contacts.contact_direction,
    contacts.contact_at_utc,
    contacts.message_count,
    contacts.handled_by_role,
    row_number() over (
        partition by contacts.support_ticket_id
        order by contacts.contact_at_utc, contacts.contact_event_id
    ) as contact_sequence_number,
    ticket_bounds.first_contact_at_utc,
    ticket_bounds.most_recent_contact_at_utc,
    ticket_bounds.contact_event_count,
    ticket_bounds.total_message_count,
    ticket_bounds.inbound_contact_count,
    ticket_bounds.outbound_contact_count,
    contacts.updated_at_utc
from contacts
left join ticket_bounds on contacts.support_ticket_id = ticket_bounds.support_ticket_id

