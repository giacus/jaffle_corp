select
    cast(order_item_id as varchar) as order_item_id,
    cast(order_id as varchar) as order_id,
    cast(product_id as varchar) as product_id,
    cast(quantity as integer) as quantity,
    cast(item_subtotal_minor as integer) as item_subtotal_minor,
    cast(item_discount_minor as integer) as item_discount_minor,
    cast(item_tax_minor as integer) as item_tax_minor,
    cast(item_subtotal_minor + item_tax_minor - item_discount_minor as integer) as item_total_minor,
    {{ shared.minor_units_to_major_units(
        'item_subtotal_minor + item_tax_minor - item_discount_minor'
    ) }} as item_total_major,
    cast(customization_count as integer) as customization_count,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('platform_app', 'raw_order_items') }}
