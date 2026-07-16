with finance_store_day as (
    select * from {{ ref('finance', 'fct_daily_store_pnl') }}
),

timing as (
    select
        store_id,
        ordered_date_utc as operating_date,
        cast(count(*) as integer) as order_timing_count,
        avg(received_to_ready_minutes) as average_received_to_ready_minutes,
        sum(case when received_to_ready_minutes <= {{ var('kitchen_ready_target_minutes', 12) }} then 1 else 0 end)
            as ready_inside_target_count
    from {{ ref('int_order_kitchen_timing') }}
    group by 1, 2
),

shift_capacity as (
    select
        store_id,
        shift_date as operating_date,
        sum(planned_minutes) as planned_minutes,
        sum(actual_minutes) as actual_minutes,
        max(team_member_count) as peak_team_member_count,
        sum(case when shift_adherence_status <> 'near_plan' then 1 else 0 end) as shift_exception_count
    from {{ ref('int_shift_capacity') }}
    group by 1, 2
),

quality as (
    select
        store_id,
        checked_date_utc as operating_date,
        sum(quality_check_count) as quality_check_count,
        sum(failed_check_count + review_check_count) as quality_exception_count
    from {{ ref('int_quality_exception_rollup') }}
    group by 1, 2
),

supply as (
    select
        store_id,
        balance_date_utc as operating_date,
        cast(count(*) as integer) as component_day_count,
        cast(sum(case when has_supply_risk then 1 else 0 end) as integer) as supply_risk_component_count
    from {{ ref('supply', 'fct_supply_risk_daily') }}
    group by 1, 2
),

incidents as (
    select
        store_id,
        opened_date_utc as operating_date,
        cast(count(*) as integer) as incident_count,
        sum(affected_orders) as affected_order_count,
        sum(incident_minutes) as incident_minutes
    from {{ ref('stg_service_incidents') }}
    group by 1, 2
)

select
    finance_store_day.store_id,
    finance_store_day.recognized_date as operating_date,
    finance_store_day.country_code,
    finance_store_day.city,
    finance_store_day.franchise_owner,
    finance_store_day.order_count,
    finance_store_day.net_revenue_usd,
    finance_store_day.estimated_gross_margin_usd,
    coalesce(timing.order_timing_count, 0) as order_timing_count,
    coalesce(timing.average_received_to_ready_minutes, 0) as average_received_to_ready_minutes,
    coalesce(timing.ready_inside_target_count, 0) as ready_inside_target_count,
    coalesce(shift_capacity.planned_minutes, 0) as planned_minutes,
    coalesce(shift_capacity.actual_minutes, 0) as actual_minutes,
    coalesce(shift_capacity.peak_team_member_count, 0) as peak_team_member_count,
    coalesce(shift_capacity.shift_exception_count, 0) as shift_exception_count,
    coalesce(quality.quality_check_count, 0) as quality_check_count,
    coalesce(quality.quality_exception_count, 0) as quality_exception_count,
    coalesce(supply.component_day_count, 0) as component_day_count,
    coalesce(supply.supply_risk_component_count, 0) as supply_risk_component_count,
    coalesce(incidents.incident_count, 0) as incident_count,
    coalesce(incidents.affected_order_count, 0) as affected_order_count,
    coalesce(incidents.incident_minutes, 0) as incident_minutes
from finance_store_day
left join timing
    on
        finance_store_day.store_id = timing.store_id
        and finance_store_day.recognized_date = timing.operating_date
left join shift_capacity
    on
        finance_store_day.store_id = shift_capacity.store_id
        and finance_store_day.recognized_date = shift_capacity.operating_date
left join quality
    on
        finance_store_day.store_id = quality.store_id
        and finance_store_day.recognized_date = quality.operating_date
left join supply
    on
        finance_store_day.store_id = supply.store_id
        and finance_store_day.recognized_date = supply.operating_date
left join incidents
    on
        finance_store_day.store_id = incidents.store_id
        and finance_store_day.recognized_date = incidents.operating_date
