select
    cast(order_id as varchar) as order_id,
    cast(customer_id as varchar) as customer_id,
    cast(store_id as varchar) as store_id,
    cast(ordered_at_utc as timestamp) as ordered_at_utc,
    cast(cast(ordered_at_utc as timestamp) as date) as ordered_date_utc,
    {{ shared.normalize_order_status('order_status') }} as order_status,
    cast(order_status as varchar) as raw_order_status,
    cast(channel as varchar) as channel,
    cast(currency as varchar) as currency,
    cast(subtotal_minor as integer) as subtotal_minor,
    cast(tax_minor as integer) as tax_minor,
    cast(discount_minor as integer) as discount_minor,
    cast(service_fee_minor as integer) as service_fee_minor,
    cast(loyalty_points_redeemed as integer) as loyalty_points_redeemed,
    cast(subtotal_minor + tax_minor + service_fee_minor - discount_minor as integer) as order_total_minor,
    {{ shared.minor_units_to_major_units(
        'subtotal_minor + tax_minor + service_fee_minor - discount_minor'
    ) }} as order_total_major,
    cast(legacy_order_number as varchar) as legacy_order_number,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('platform_app', 'raw_orders') }}
