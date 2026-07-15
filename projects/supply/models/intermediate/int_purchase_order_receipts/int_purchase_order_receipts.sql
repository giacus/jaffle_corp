with purchase_orders as (
    select * from {{ ref('stg_purchase_orders') }}
),

exchange_rates as (
    select * from {{ ref('jaffle_platform', 'dim_exchange_rates') }}
),

locations as (
    select * from {{ ref('jaffle_platform', 'dim_locations') }}
)

select
    purchase_orders.purchase_order_id,
    purchase_orders.store_id,
    locations.country_code,
    locations.city,
    purchase_orders.component_id,
    purchase_orders.supplier_name,
    purchase_orders.ordered_at_utc,
    purchase_orders.expected_at_utc,
    purchase_orders.received_at_utc,
    cast(purchase_orders.received_at_utc as date) as received_date_utc,
    purchase_orders.purchase_order_status,
    purchase_orders.raw_purchase_order_status,
    purchase_orders.quantity_ordered,
    purchase_orders.quantity_received,
    purchase_orders.unit,
    purchase_orders.unit_cost_minor,
    purchase_orders.unit_cost_major,
    purchase_orders.currency,
    exchange_rates.usd_rate,
    {{ jaffle_shared.fx_to_usd('purchase_orders.unit_cost_major', 'purchase_orders.currency', 'exchange_rates.usd_rate') }}
        as unit_cost_usd,
    {{ jaffle_shared.safe_divide('purchase_orders.quantity_received', 'purchase_orders.quantity_ordered') }}
        as receipt_fill_rate,
    {{ jaffle_shared.minutes_between('purchase_orders.expected_at_utc', 'purchase_orders.received_at_utc') }}
        as receipt_delay_minutes,
    purchase_orders.received_at_utc > purchase_orders.expected_at_utc as is_late_receipt,
    purchase_orders.updated_at_utc
from purchase_orders
left join exchange_rates
    on
        purchase_orders.currency = exchange_rates.currency
        and cast(purchase_orders.received_at_utc as date) = exchange_rates.rate_date
left join locations
    on purchase_orders.store_id = locations.store_id
