with rules as (
    select * from {{ ref('stg_substitution_rules') }}
),

availability as (
    select * from {{ ref('int_product_store_day_availability') }}
),

menu_items as (
    select * from {{ ref('int_menu_product_windows') }}
)

select
    {{ jaffle_shared.stable_hash(['rules.substitution_rule_id', 'availability.available_date_utc']) }} as substitution_coverage_key,
    rules.substitution_rule_id,
    rules.store_id,
    availability.available_date_utc,
    rules.unavailable_product_id,
    unavailable_item.product_name as unavailable_product_name,
    rules.substitute_product_id,
    substitute_item.product_name as substitute_product_name,
    rules.priority_rank,
    rules.reason_code,
    availability.product_store_day_status,
    availability.outage_minutes,
    case
        when availability.product_store_day_status in ('blocked', 'constrained') then true
        else false
    end as rule_was_needed,
    case when substitute_item.product_id is not null then true else false end as substitute_is_published
from rules
left join availability
    on rules.store_id = availability.store_id
    and rules.unavailable_product_id = availability.product_id
    and cast(availability.available_date_utc as timestamp) >= rules.effective_from_utc
    and cast(availability.available_date_utc as timestamp) < coalesce(rules.effective_to_utc, cast('2999-12-31' as timestamp))
left join menu_items as unavailable_item
    on rules.store_id = unavailable_item.store_id
    and rules.unavailable_product_id = unavailable_item.product_id
left join menu_items as substitute_item
    on rules.store_id = substitute_item.store_id
    and rules.substitute_product_id = substitute_item.product_id
