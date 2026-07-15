select *
from {{ ref('fct_menu_goal_progress') }}
where
    unit_goal_attainment_rate < 0
    or revenue_goal_attainment_rate < 0
