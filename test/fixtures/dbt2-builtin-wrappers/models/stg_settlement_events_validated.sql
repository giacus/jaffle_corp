select
    settlement_event_id,
    customer_id,
    settled_amount
from {{ ref('stg_settlement_events') }}
where settlement_event_id is not null
  and customer_id is not null
