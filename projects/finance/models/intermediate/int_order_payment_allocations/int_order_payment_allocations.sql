with orders as (
    select * from {{ ref('platform', 'fct_orders') }}
),

order_ratios as (
    select
        *,
        case
            when order_total_major = 0 then 0
            else order_total_usd / order_total_major
        end as usd_per_order_currency_unit
    from orders
)

select
    order_id,
    customer_id,
    store_id,
    ordered_at_utc,
    ordered_date_utc,
    order_status,
    channel,
    currency,
    country_code,
    city,
    tax_jurisdiction,
    franchise_owner,
    subtotal_minor,
    tax_minor,
    discount_minor,
    service_fee_minor,
    order_total_minor,
    order_total_major,
    order_total_usd,
    captured_amount_major,
    captured_amount_major * usd_per_order_currency_unit as captured_amount_usd,
    refunded_amount_major,
    refunded_amount_major * usd_per_order_currency_unit as refunded_amount_usd,
    payment_attempt_count,
    refund_event_count,
    has_failed_payment,
    is_completed_order,
    is_cancelled_order,
    case
        when has_failed_payment then 'payment_risk'
        when is_cancelled_order then 'cancelled'
        when refund_event_count > 0 then 'refund_review'
        when is_completed_order then 'recognized'
        else 'pending'
    end as revenue_quality_status
from order_ratios
