select
    cast(goal_id as varchar) as goal_id,
    cast(store_id as varchar) as store_id,
    cast(product_family as varchar) as product_family,
    cast(goal_week_start_utc as date) as goal_week_start_utc,
    cast(target_units as integer) as target_units,
    cast(target_net_revenue_usd as double) as target_net_revenue_usd,
    cast(target_margin_usd as double) as target_margin_usd,
    cast(owner_role as varchar) as owner_role
from {{ source('merchandising_app', 'raw_menu_goals') }}
