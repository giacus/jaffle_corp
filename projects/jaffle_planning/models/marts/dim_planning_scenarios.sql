select
    capacity_scenario_window_key,
    scenario_id,
    store_id,
    scenario_name,
    effective_from_utc,
    effective_to_utc,
    target_orders_per_hour,
    target_ready_minutes,
    target_team_hours,
    updated_at_utc
from {{ ref('int_capacity_scenario_windows') }}
