select
    cast(waste_event_id as varchar) as waste_event_id,
    cast(store_id as varchar) as store_id,
    cast(component_id as varchar) as component_id,
    cast(product_id as varchar) as product_id,
    cast(order_id as varchar) as order_id,
    cast(wasted_at_utc as timestamp) as wasted_at_utc,
    cast(cast(wasted_at_utc as timestamp) as date) as wasted_date_utc,
    cast(wasted_quantity as double) as wasted_quantity,
    cast(unit as varchar) as unit,
    cast(reason_code as varchar) as reason_code,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_supply_app', 'raw_waste_events') }}

