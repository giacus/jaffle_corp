select
    cast(substitution_rule_id as varchar) as substitution_rule_id,
    cast(store_id as varchar) as store_id,
    cast(unavailable_product_id as varchar) as unavailable_product_id,
    cast(substitute_product_id as varchar) as substitute_product_id,
    cast(priority_rank as integer) as priority_rank,
    cast(effective_from_utc as timestamp) as effective_from_utc,
    cast(nullif(cast(effective_to_utc as varchar), '') as timestamp) as effective_to_utc,
    cast(reason_code as varchar) as reason_code
from {{ source('merchandising_app', 'raw_substitution_rules') }}
