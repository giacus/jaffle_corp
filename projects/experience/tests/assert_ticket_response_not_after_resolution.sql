select *
from {{ ref('fct_support_tickets') }}
where
    first_response_at_utc is not null
    and resolved_at_utc is not null
    and first_response_at_utc > resolved_at_utc
