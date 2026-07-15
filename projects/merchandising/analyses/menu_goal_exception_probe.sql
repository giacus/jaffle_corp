select
    store_id,
    product_family,
    goal_week_start_utc,
    target_units,
    actual_units,
    unit_goal_attainment_rate,
    unit_goal_status
from {{ ref('fct_menu_goal_progress') }}
where unit_goal_status in ('behind', 'not_scored')
order by goal_week_start_utc, store_id, product_family
