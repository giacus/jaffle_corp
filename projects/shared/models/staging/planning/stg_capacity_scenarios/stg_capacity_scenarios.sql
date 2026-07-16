select
    cast(scenario_id as varchar) as scenario_id,
    cast(store_id as varchar) as store_id,
    cast(scenario_name as varchar) as scenario_name,
    cast(effective_from_utc as timestamp) as effective_from_utc,
    cast(effective_to_utc as timestamp) as effective_to_utc,
    cast(target_orders_per_hour as double) as target_orders_per_hour,
    cast(target_ready_minutes as double) as target_ready_minutes,
    cast(target_team_hours as double) as target_team_hours,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('planning_app', 'raw_capacity_scenarios') }}
