select
    cast(inventory_count_id as varchar) as inventory_count_id,
    cast(store_id as varchar) as store_id,
    cast(component_id as varchar) as component_id,
    cast(counted_at_utc as timestamp) as counted_at_utc,
    cast(cast(counted_at_utc as timestamp) as date) as counted_date_utc,
    cast(quantity_on_hand as double) as quantity_on_hand,
    cast(unit as varchar) as unit,
    cast(count_quality as varchar) as count_quality,
    cast(source_version as varchar) as source_version,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_supply_app', 'raw_inventory_counts') }}
