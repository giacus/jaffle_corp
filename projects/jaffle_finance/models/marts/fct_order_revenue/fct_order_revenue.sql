with payment_allocations as (
    select * from {{ ref('int_order_payment_allocations') }}
),

costs as (
    select * from {{ ref('int_order_cost_rollup') }}
)

select
    {{ jaffle_shared.stable_hash(['payment_allocations.order_id', 'payment_allocations.ordered_date_utc']) }}
        as order_revenue_key,
    payment_allocations.order_id,
    payment_allocations.customer_id,
    payment_allocations.store_id,
    payment_allocations.ordered_at_utc,
    payment_allocations.ordered_date_utc as recognized_date,
    payment_allocations.order_status,
    payment_allocations.channel,
    payment_allocations.currency,
    payment_allocations.country_code,
    payment_allocations.city,
    payment_allocations.tax_jurisdiction,
    payment_allocations.franchise_owner,
    payment_allocations.order_total_usd as gross_revenue_usd,
    payment_allocations.captured_amount_usd,
    payment_allocations.refunded_amount_usd,
    payment_allocations.captured_amount_usd - payment_allocations.refunded_amount_usd
        as net_revenue_usd,
    {{ jaffle_shared.minor_units_to_major_units('payment_allocations.tax_minor') }}
        as tax_amount_major,
    {{ jaffle_shared.minor_units_to_major_units('payment_allocations.discount_minor') }}
        as discount_amount_major,
    {{ jaffle_shared.minor_units_to_major_units('payment_allocations.service_fee_minor') }}
        as service_fee_major,
    coalesce(costs.estimated_supply_cost_usd, 0) as estimated_supply_cost_usd,
    payment_allocations.captured_amount_usd
    - payment_allocations.refunded_amount_usd
    - coalesce(costs.estimated_supply_cost_usd, 0) as estimated_gross_margin_usd,
    coalesce(costs.order_item_count, 0) as order_item_count,
    coalesce(costs.total_item_quantity, 0) as total_item_quantity,
    payment_allocations.payment_attempt_count,
    payment_allocations.refund_event_count,
    payment_allocations.revenue_quality_status
from payment_allocations
left join costs on payment_allocations.order_id = costs.order_id
