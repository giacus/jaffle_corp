with revenue as (
    select * from {{ ref('fct_order_revenue') }}
),

component_costs as (
    select
        order_id,
        sum(recipe_expected_component_cost_usd) as recipe_expected_component_cost_usd,
        sum(platform_estimated_supply_cost_major) as platform_estimated_supply_cost_major,
        cast(sum(component_count) as integer) as component_count
    from {{ ref('int_order_component_cost_bridge') }}
    group by 1
)

select
    revenue.order_id,
    revenue.customer_id,
    revenue.store_id,
    revenue.recognized_date,
    revenue.order_status,
    revenue.channel,
    revenue.country_code,
    revenue.city,
    revenue.gross_revenue_usd,
    revenue.captured_amount_usd,
    revenue.refunded_amount_usd,
    revenue.net_revenue_usd,
    revenue.estimated_supply_cost_usd as platform_supply_cost_usd,
    coalesce(component_costs.recipe_expected_component_cost_usd, 0) as recipe_expected_component_cost_usd,
    coalesce(component_costs.recipe_expected_component_cost_usd, 0)
    - revenue.estimated_supply_cost_usd as recipe_cost_variance_usd,
    revenue.net_revenue_usd
    - coalesce(component_costs.recipe_expected_component_cost_usd, 0) as recipe_margin_usd,
    revenue.estimated_gross_margin_usd as platform_margin_usd,
    revenue.estimated_gross_margin_usd
    - (
        revenue.net_revenue_usd
        - coalesce(component_costs.recipe_expected_component_cost_usd, 0)
    ) as margin_method_variance_usd,
    coalesce(component_costs.component_count, 0) as component_count,
    revenue.order_item_count,
    revenue.total_item_quantity,
    revenue.payment_attempt_count,
    revenue.refund_event_count,
    revenue.revenue_quality_status
from revenue
left join component_costs on revenue.order_id = component_costs.order_id
