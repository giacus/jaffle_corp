with counts as (
    select
        store_id,
        component_id,
        counted_date_utc as balance_date_utc,
        max(quantity_on_hand) as counted_quantity,
        min(unit) as unit,
        bool_or(count_quality = 'review') as has_count_review
    from {{ ref('stg_inventory_counts') }}
    group by 1, 2, 3
),

usage as (
    select
        store_id,
        component_id,
        usage_date_utc as balance_date_utc,
        min(unit) as unit,
        sum(expected_used_quantity) as expected_used_quantity,
        sum(expected_recipe_waste_quantity) as expected_recipe_waste_quantity
    from {{ ref('int_component_daily_usage') }}
    group by 1, 2, 3
),

receipts as (
    select
        store_id,
        component_id,
        received_date_utc as balance_date_utc,
        min(unit) as unit,
        sum(quantity_received) as received_quantity,
        sum(quantity_received * unit_cost_usd) as received_cost_usd,
        bool_or(is_late_receipt) as has_late_receipt
    from {{ ref('int_purchase_order_receipts') }}
    where received_date_utc is not null
    group by 1, 2, 3
),

waste as (
    select
        store_id,
        component_id,
        wasted_date_utc as balance_date_utc,
        min(unit) as unit,
        sum(wasted_quantity) as observed_waste_quantity,
        cast(count(*) as integer) as waste_event_count
    from {{ ref('stg_waste_events') }}
    group by 1, 2, 3
),

component_days as (
    select
        store_id,
        component_id,
        balance_date_utc
    from counts
    union
    select
        store_id,
        component_id,
        balance_date_utc
    from usage
    union
    select
        store_id,
        component_id,
        balance_date_utc
    from receipts
    union
    select
        store_id,
        component_id,
        balance_date_utc
    from waste
)

select
    component_days.store_id,
    component_days.component_id,
    component_days.balance_date_utc,
    coalesce(counts.unit, usage.unit, receipts.unit, waste.unit) as unit,
    coalesce(counts.counted_quantity, 0) as counted_quantity,
    coalesce(receipts.received_quantity, 0) as received_quantity,
    coalesce(usage.expected_used_quantity, 0) as expected_used_quantity,
    coalesce(usage.expected_recipe_waste_quantity, 0) as expected_recipe_waste_quantity,
    coalesce(waste.observed_waste_quantity, 0) as observed_waste_quantity,
    coalesce(waste.waste_event_count, 0) as waste_event_count,
    coalesce(receipts.received_cost_usd, 0) as received_cost_usd,
    coalesce(counts.has_count_review, false) as has_count_review,
    coalesce(receipts.has_late_receipt, false) as has_late_receipt,
    coalesce(counts.counted_quantity, 0)
    + coalesce(receipts.received_quantity, 0)
    - coalesce(usage.expected_used_quantity, 0)
    - coalesce(waste.observed_waste_quantity, 0) as estimated_closing_quantity
from component_days
left join counts
    on
        component_days.store_id = counts.store_id
        and component_days.component_id = counts.component_id
        and component_days.balance_date_utc = counts.balance_date_utc
left join usage
    on
        component_days.store_id = usage.store_id
        and component_days.component_id = usage.component_id
        and component_days.balance_date_utc = usage.balance_date_utc
left join receipts
    on
        component_days.store_id = receipts.store_id
        and component_days.component_id = receipts.component_id
        and component_days.balance_date_utc = receipts.balance_date_utc
left join waste
    on
        component_days.store_id = waste.store_id
        and component_days.component_id = waste.component_id
        and component_days.balance_date_utc = waste.balance_date_utc
