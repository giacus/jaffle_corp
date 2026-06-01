select
    pairing_id,
    anchor_product_id,
    paired_product_id,
    pairing_reason,
    effective_from_utc,
    effective_to_utc,
    pairing_rank
from {{ ref('stg_product_pairings') }}
