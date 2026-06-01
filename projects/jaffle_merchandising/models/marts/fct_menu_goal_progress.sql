select
    menu_goal_progress_key,
    goal_id,
    store_id,
    product_family,
    goal_week_start_utc,
    target_units,
    target_net_revenue_usd,
    target_margin_usd,
    owner_role,
    cast(actual_units as integer) as actual_units,
    actual_item_revenue_usd,
    estimated_actual_margin_usd,
    unit_goal_attainment_rate,
    revenue_goal_attainment_rate,
    unit_goal_status,
    average_expected_margin_rate
from {{ ref('int_merch_goal_progress') }}
