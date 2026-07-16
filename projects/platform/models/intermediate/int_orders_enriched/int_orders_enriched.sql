with orders as (
    select * from {{ ref('stg_orders') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

fx_rates as (
    select * from {{ ref('stg_fx_rates') }}
),

payments as (
    select
        order_id,
        sum(case when payment_status = 'captured' then amount_minor else 0 end) as captured_amount_minor,
        cast(count(*) as integer) as payment_attempt_count,
        bool_or(payment_status = 'failed') as has_failed_payment
    from {{ ref('stg_payments') }}
    group by 1
),

refunds as (
    select
        order_id,
        sum(refund_amount_minor) as refunded_amount_minor,
        cast(count(*) as integer) as refund_event_count
    from {{ ref('stg_refunds') }}
    group by 1
)

select
    orders.order_id,
    orders.customer_id,
    orders.store_id,
    stores.store_name,
    stores.country_code,
    stores.city,
    stores.timezone_name,
    stores.operating_currency,
    stores.tax_jurisdiction,
    stores.franchise_owner,
    stores.is_dark_kitchen,
    orders.ordered_at_utc,
    orders.ordered_date_utc,
    orders.order_status,
    orders.raw_order_status,
    orders.channel,
    orders.currency,
    orders.subtotal_minor,
    orders.tax_minor,
    orders.discount_minor,
    orders.service_fee_minor,
    orders.loyalty_points_redeemed,
    orders.order_total_minor,
    orders.order_total_major,
    fx_rates.usd_rate,
    {{ shared.fx_to_usd('orders.order_total_major', 'orders.currency', 'fx_rates.usd_rate') }}
        as order_total_usd,
    cast(coalesce(payments.captured_amount_minor, 0) as integer) as captured_amount_minor,
    {{ shared.minor_units_to_major_units('coalesce(payments.captured_amount_minor, 0)') }}
        as captured_amount_major,
    cast(coalesce(refunds.refunded_amount_minor, 0) as integer) as refunded_amount_minor,
    {{ shared.minor_units_to_major_units('coalesce(refunds.refunded_amount_minor, 0)') }}
        as refunded_amount_major,
    coalesce(payments.payment_attempt_count, 0) as payment_attempt_count,
    coalesce(refunds.refund_event_count, 0) as refund_event_count,
    coalesce(payments.has_failed_payment, false) as has_failed_payment,
    orders.order_status = 'completed' as is_completed_order,
    orders.order_status = 'cancelled' as is_cancelled_order,
    orders.legacy_order_number,
    orders.updated_at_utc
from orders
left join stores on orders.store_id = stores.store_id
left join fx_rates
    on
        orders.currency = fx_rates.currency
        and orders.ordered_date_utc = fx_rates.rate_date
left join payments on orders.order_id = payments.order_id
left join refunds on orders.order_id = refunds.order_id
