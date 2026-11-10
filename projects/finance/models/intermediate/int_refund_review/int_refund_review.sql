{{ config(enabled=var('include_refund_review', false) | as_bool) }}

select
    order_id,
    customer_id,
    refunded_amount_usd,
    refund_event_count
from {{ ref('int_order_payment_allocations') }}
where refund_event_count > 0
