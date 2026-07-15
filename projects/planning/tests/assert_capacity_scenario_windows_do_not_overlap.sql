with windows as (
    select
        capacity_scenario_window_key,
        store_id,
        scenario_name,
        effective_from_utc,
        effective_to_utc
    from {{ ref('dim_planning_scenarios') }}
),

overlapping_windows as (
    select
        left_window.capacity_scenario_window_key as left_window_key,
        right_window.capacity_scenario_window_key as right_window_key
    from windows as left_window
    inner join windows as right_window
        on
            left_window.store_id = right_window.store_id
            and left_window.scenario_name = right_window.scenario_name
            and left_window.capacity_scenario_window_key < right_window.capacity_scenario_window_key
            and left_window.effective_from_utc < right_window.effective_to_utc
            and right_window.effective_from_utc < left_window.effective_to_utc
)

select *
from overlapping_windows
