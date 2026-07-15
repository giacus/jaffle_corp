select
    operating_date,
    store_id,
    store_day_status,
    ready_target_rate,
    quality_exception_count,
    supply_risk_component_count,
    incident_count
from {{ ref('fct_store_day_operations') }}
order by operating_date, store_id
