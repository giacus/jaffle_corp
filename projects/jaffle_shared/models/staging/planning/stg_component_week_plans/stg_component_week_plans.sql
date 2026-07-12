select
    cast(plan_id as varchar) as plan_id,
    cast(store_id as varchar) as store_id,
    cast(component_id as varchar) as component_id,
    cast(plan_week_start_utc as date) as plan_week_start_utc,
    cast(planned_receipt_quantity as double) as planned_receipt_quantity,
    cast(planned_usage_quantity as double) as planned_usage_quantity,
    cast(planned_waste_quantity as double) as planned_waste_quantity,
    cast(scenario_name as varchar) as scenario_name,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_planning_app', 'raw_component_week_plans') }}
