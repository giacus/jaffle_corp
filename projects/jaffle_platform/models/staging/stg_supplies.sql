select
    cast(supply_id as varchar) as supply_id,
    cast(product_id as varchar) as product_id,
    cast(supplier_name as varchar) as supplier_name,
    upper(cast(supplier_country_code as varchar)) as supplier_country_code,
    cast(unit_cost_minor as integer) as unit_cost_minor,
    {{ jaffle_shared.minor_units_to_major_units('unit_cost_minor') }} as unit_cost_major,
    cast(currency as varchar) as currency,
    cast(perishable as boolean) as perishable,
    cast(lead_time_days as integer) as lead_time_days,
    cast(replenishment_mode as varchar) as replenishment_mode,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_app', 'raw_supplies') }}

