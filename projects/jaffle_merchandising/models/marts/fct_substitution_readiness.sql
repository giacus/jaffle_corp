select
    substitution_coverage_key,
    substitution_rule_id,
    store_id,
    available_date_utc,
    unavailable_product_id,
    unavailable_product_name,
    substitute_product_id,
    substitute_product_name,
    priority_rank,
    reason_code,
    product_store_day_status,
    outage_minutes,
    rule_was_needed,
    substitute_is_published,
    case
        when rule_was_needed and substitute_is_published then 'ready'
        when rule_was_needed then 'missing_substitute'
        else 'not_needed'
    end as substitution_readiness_status
from {{ ref('int_substitution_coverage') }}
