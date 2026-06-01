select
    opened_date_utc,
    normalized_issue_type,
    count(*) as ticket_count,
    sum(case when met_first_response_sla then 1 else 0 end) as met_first_response_sla_count,
    avg(first_response_minutes) as average_first_response_minutes
from {{ ref('fct_support_tickets') }}
group by 1, 2
order by 1, 2

