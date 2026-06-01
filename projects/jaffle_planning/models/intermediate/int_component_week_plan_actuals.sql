with plans as (
    select * from {{ ref('stg_component_week_plans') }}
),

actuals as (
    select
        store_id,
        component_id,
        {{ jaffle_shared.week_start('balance_date_utc') }} as actual_week_start_utc,
        sum(received_quantity) as actual_received_quantity,
        sum(expected_used_quantity) as actual_used_quantity,
        sum(observed_waste_quantity) as actual_waste_quantity,
        sum(received_cost_usd) as actual_received_cost_usd
    from {{ ref('fct_inventory_daily') }}
    group by 1, 2, 3
),

components as (
    select component_id, component_name, component_family, recipe_unit from {{ ref('dim_components') }}
)

select
    {{ jaffle_shared.component_store_week_key('plans.component_id', 'plans.store_id', 'plans.plan_week_start_utc') }} as component_week_plan_variance_key,
    plans.plan_id,
    plans.store_id,
    plans.component_id,
    components.component_name,
    components.component_family,
    components.recipe_unit,
    plans.plan_week_start_utc,
    plans.scenario_name,
    plans.planned_receipt_quantity,
    plans.planned_usage_quantity,
    plans.planned_waste_quantity,
    coalesce(actuals.actual_received_quantity, 0) as actual_received_quantity,
    coalesce(actuals.actual_used_quantity, 0) as actual_used_quantity,
    coalesce(actuals.actual_waste_quantity, 0) as actual_waste_quantity,
    coalesce(actuals.actual_received_cost_usd, 0) as actual_received_cost_usd,
    {{ jaffle_shared.forecast_error('coalesce(actuals.actual_used_quantity, 0)', 'plans.planned_usage_quantity') }} as usage_quantity_variance,
    {{ jaffle_shared.plan_variance_status('coalesce(actuals.actual_used_quantity, 0)', 'plans.planned_usage_quantity') }} as usage_variance_status,
    plans.updated_at_utc
from plans
left join actuals
    on plans.store_id = actuals.store_id
    and plans.component_id = actuals.component_id
    and plans.plan_week_start_utc = actuals.actual_week_start_utc
left join components on plans.component_id = components.component_id
