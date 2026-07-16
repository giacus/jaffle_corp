select
    {{ shared.stable_hash(['store_id', 'component_id', 'balance_date_utc']) }} as supply_risk_daily_key,
    store_id,
    component_id,
    balance_date_utc,
    unit,
    counted_quantity,
    estimated_closing_quantity,
    expected_used_quantity,
    observed_waste_quantity,
    has_count_review,
    has_late_receipt,
    case
        when estimated_closing_quantity < 0 then 'negative_balance'
        when estimated_closing_quantity < expected_used_quantity then 'low_cover'
        when observed_waste_quantity > expected_used_quantity then 'waste_review'
        when has_count_review or has_late_receipt then 'needs_review'
        else 'healthy'
    end as supply_risk_status,
    estimated_closing_quantity < 0
    or estimated_closing_quantity < expected_used_quantity
    or observed_waste_quantity > expected_used_quantity
    or has_count_review
    or has_late_receipt as has_supply_risk
from {{ ref('int_inventory_daily_balance') }}
