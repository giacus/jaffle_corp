select
    {{ shared.stable_hash(['anchor_product_id', 'paired_product_id', 'ordered_date_utc']) }} as basket_pair_affinity_key,
    anchor_product_id,
    paired_product_id,
    ordered_date_utc,
    pairing_id,
    pairing_reason,
    pairing_rank,
    is_curated_pair,
    count(distinct order_id) as paired_order_count,
    sum(paired_item_total_major) as paired_item_total_major
from {{ ref('int_basket_pair_observations') }}
group by 1, 2, 3, 4, 5, 6, 7, 8
