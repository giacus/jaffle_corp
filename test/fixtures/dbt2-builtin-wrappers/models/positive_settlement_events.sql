select
    settlement_event_id,
    customer_id,
    settled_amount
from {{ ref('stg_settlement_events') }}
where settled_amount > 0
