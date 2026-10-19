select
    settlement_event_id,
    customer_id,
    occurred_at,
    cast(occurred_at as date) as occurred_on,
    gross_amount,
    settled_amount,
    case when settled_amount > 0 then 1 else 0 end as settled_event_count
from {{ source('legacy.settlement_gateway', 'settlement_events') }}
