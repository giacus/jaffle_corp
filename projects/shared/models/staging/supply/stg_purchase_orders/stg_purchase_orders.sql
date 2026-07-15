select
    cast(purchase_order_id as varchar) as purchase_order_id,
    cast(store_id as varchar) as store_id,
    cast(component_id as varchar) as component_id,
    cast(supplier_name as varchar) as supplier_name,
    cast(ordered_at_utc as timestamp) as ordered_at_utc,
    cast(expected_at_utc as timestamp) as expected_at_utc,
    cast(received_at_utc as timestamp) as received_at_utc,
    {{ jaffle_shared.normalize_po_status('status') }} as purchase_order_status,
    cast(status as varchar) as raw_purchase_order_status,
    cast(quantity_ordered as double) as quantity_ordered,
    cast(quantity_received as double) as quantity_received,
    cast(unit as varchar) as unit,
    cast(unit_cost_minor as integer) as unit_cost_minor,
    {{ jaffle_shared.minor_units_to_major_units('unit_cost_minor') }} as unit_cost_major,
    cast(currency as varchar) as currency,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_supply_app', 'raw_purchase_orders') }}
