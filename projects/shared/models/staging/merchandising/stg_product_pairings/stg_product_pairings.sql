select
    cast(pairing_id as varchar) as pairing_id,
    cast(anchor_product_id as varchar) as anchor_product_id,
    cast(paired_product_id as varchar) as paired_product_id,
    cast(pairing_reason as varchar) as pairing_reason,
    cast(effective_from_utc as timestamp) as effective_from_utc,
    cast(nullif(cast(effective_to_utc as varchar), '') as timestamp) as effective_to_utc,
    cast(pairing_rank as integer) as pairing_rank
from {{ source('merchandising_app', 'raw_product_pairings') }}
