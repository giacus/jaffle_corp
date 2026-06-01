select *
from {{ ref('fct_store_day_operations') }}
where coalesce(ready_target_rate, 0) < 0
    or coalesce(ready_target_rate, 0) > 1
    or coalesce(quality_exception_rate, 0) < 0
    or coalesce(quality_exception_rate, 0) > 1
    or coalesce(supply_risk_component_rate, 0) < 0
    or coalesce(supply_risk_component_rate, 0) > 1

