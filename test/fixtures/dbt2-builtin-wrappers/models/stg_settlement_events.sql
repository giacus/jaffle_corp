select
    settlement_event_id,
    customer_id,
    settled_amount
from {{ gateway_settlements('settlement_gateway', 'raw_settlement_events') }}
