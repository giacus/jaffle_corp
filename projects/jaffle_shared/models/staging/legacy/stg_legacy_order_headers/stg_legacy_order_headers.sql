select
    legacy_order_number as order_no,
    order_id as modern_order_id,
    customer_id as cust,
    store_id as shop,
    cast(ordered_at_utc as date) as business_dt,
    {{ legacy_status_bucket('order_status') }} as old_status_bucket,
    currency as money_kind,
    order_total_major as gross_amt,
    refunded_amount_major as refund_amt,
    captured_amount_major - refunded_amount_major as net_amt,
    case
        when refund_event_count > 0 then 'Y'
        else 'N'
    end as has_refund_flag,
    updated_at_utc as load_ts
from {{ jaffle_shared.legacy_platform_relation('fct_orders') }}
