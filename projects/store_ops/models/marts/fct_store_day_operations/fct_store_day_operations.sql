select
    {{ shared.stable_hash(['store_id', 'operating_date']) }} as store_day_operations_key,
    store_id,
    operating_date,
    country_code,
    city,
    franchise_owner,
    order_count,
    net_revenue_usd,
    estimated_gross_margin_usd,
    order_timing_count,
    average_received_to_ready_minutes,
    cast(ready_inside_target_count as integer) as ready_inside_target_count,
    {{ shared.safe_divide('ready_inside_target_count', 'order_timing_count') }} as ready_target_rate,
    planned_minutes,
    actual_minutes,
    peak_team_member_count,
    {{ shared.safe_divide('order_count', 'actual_minutes') }} as orders_per_actual_minute,
    shift_exception_count,
    quality_check_count,
    quality_exception_count,
    {{ shared.safe_divide('quality_exception_count', 'quality_check_count') }} as quality_exception_rate,
    component_day_count,
    supply_risk_component_count,
    {{ shared.safe_divide('supply_risk_component_count', 'component_day_count') }} as supply_risk_component_rate,
    incident_count,
    affected_order_count,
    incident_minutes,
    case
        when incident_count > 0 or quality_exception_count > 0 or supply_risk_component_count > 0 then 'watch'
        when ready_inside_target_count < order_timing_count then 'slow'
        else 'steady'
    end as store_day_status
from {{ ref('int_store_day_operating_inputs') }}
