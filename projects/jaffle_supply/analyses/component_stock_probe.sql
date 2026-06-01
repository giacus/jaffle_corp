select
    balance_date_utc,
    store_id,
    component_id,
    supply_risk_status,
    estimated_closing_quantity,
    observed_waste_quantity
from {{ ref('fct_supply_risk_daily') }}
order by balance_date_utc, store_id, component_id

