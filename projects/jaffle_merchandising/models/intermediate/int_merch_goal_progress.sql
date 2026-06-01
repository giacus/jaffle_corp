with goals as (
    select * from {{ ref('stg_menu_goals') }}
),

actuals as (
    select
        orders.store_id,
        items.product_family,
        {{ jaffle_shared.week_start('orders.ordered_date_utc') }} as ordered_week_start_utc,
        sum(items.quantity) as actual_units,
        sum(items.item_total_major) as actual_item_revenue_usd
    from {{ ref('fct_order_items') }} as items
    inner join {{ ref('fct_orders') }} as orders
        on items.order_id = orders.order_id
    where orders.is_completed_order
    group by 1, 2, 3
),

margin_baseline as (
    select
        store_id,
        product_family,
        avg(expected_recipe_margin_rate) as average_expected_margin_rate
    from {{ ref('int_menu_item_margin_baseline') }}
    group by 1, 2
)

select
    {{ jaffle_shared.stable_hash(['goals.goal_id', 'goals.store_id', 'goals.product_family']) }} as menu_goal_progress_key,
    goals.goal_id,
    goals.store_id,
    goals.product_family,
    goals.goal_week_start_utc,
    goals.target_units,
    goals.target_net_revenue_usd,
    goals.target_margin_usd,
    goals.owner_role,
    coalesce(actuals.actual_units, 0) as actual_units,
    coalesce(actuals.actual_item_revenue_usd, 0) as actual_item_revenue_usd,
    coalesce(actuals.actual_item_revenue_usd, 0) * coalesce(margin_baseline.average_expected_margin_rate, 0) as estimated_actual_margin_usd,
    {{ jaffle_shared.safe_divide('coalesce(actuals.actual_units, 0)', 'goals.target_units') }} as unit_goal_attainment_rate,
    {{ jaffle_shared.safe_divide('coalesce(actuals.actual_item_revenue_usd, 0)', 'goals.target_net_revenue_usd') }} as revenue_goal_attainment_rate,
    {{ jaffle_shared.goal_attainment_status(jaffle_shared.safe_divide('coalesce(actuals.actual_units, 0)', 'goals.target_units')) }} as unit_goal_status,
    margin_baseline.average_expected_margin_rate
from goals
left join actuals
    on goals.store_id = actuals.store_id
    and goals.product_family = actuals.product_family
    and goals.goal_week_start_utc = actuals.ordered_week_start_utc
left join margin_baseline
    on goals.store_id = margin_baseline.store_id
    and goals.product_family = margin_baseline.product_family
