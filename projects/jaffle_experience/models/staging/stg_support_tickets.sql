select
    cast(support_ticket_id as varchar) as support_ticket_id,
    cast(customer_id as varchar) as customer_id,
    nullif(cast(order_id as varchar), '') as order_id,
    cast(store_id as varchar) as store_id,
    cast(opened_at_utc as timestamp) as opened_at_utc,
    cast(nullif(cast(first_response_at_utc as varchar), '') as timestamp) as first_response_at_utc,
    cast(nullif(cast(resolved_at_utc as varchar), '') as timestamp) as resolved_at_utc,
    cast(cast(opened_at_utc as timestamp) as date) as opened_date_utc,
    {{ jaffle_shared.normalize_ticket_issue('issue_type') }} as normalized_issue_type,
    cast(issue_type as varchar) as raw_issue_type,
    lower(cast(ticket_status as varchar)) as ticket_status,
    cast(resolution_type as varchar) as resolution_type,
    cast(nullif(cast(satisfaction_score as varchar), '') as integer) as satisfaction_score,
    cast(concession_minor as integer) as concession_minor,
    {{ jaffle_shared.minor_units_to_major_units('concession_minor') }} as concession_major,
    cast(currency as varchar) as currency,
    {{ jaffle_shared.minutes_between(
        'opened_at_utc',
        "nullif(cast(first_response_at_utc as varchar), '')"
    ) }} as first_response_minutes,
    {{ jaffle_shared.minutes_between(
        'opened_at_utc',
        "nullif(cast(resolved_at_utc as varchar), '')"
    ) }} as resolution_minutes,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_experience_app', 'raw_support_tickets') }}
