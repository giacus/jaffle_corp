select
    {{ shared.stable_hash(['store_id', 'component_id', 'balance_date_utc']) }} as inventory_daily_key,
    store_id,
    component_id,
    balance_date_utc,
    unit,
    counted_quantity,
    received_quantity,
    expected_used_quantity,
    expected_recipe_waste_quantity,
    observed_waste_quantity,
    waste_event_count,
    received_cost_usd,
    estimated_closing_quantity,
    has_count_review,
    has_late_receipt
from {{ ref('int_inventory_daily_balance') }}
