with item_pairs as (
    select
        left_items.order_id,
        left_items.product_id as anchor_product_id,
        right_items.product_id as paired_product_id,
        left_items.ordered_date_utc,
        left_items.item_total_major as anchor_item_total_major,
        right_items.item_total_major as paired_item_total_major
    from {{ ref('platform', 'fct_order_items') }} as left_items
    inner join {{ ref('platform', 'fct_order_items') }} as right_items
        on
            left_items.order_id = right_items.order_id
            and left_items.product_id < right_items.product_id
),

pairings as (
    select * from {{ ref('stg_product_pairings') }}
)

select
    {{ shared.stable_hash(['item_pairs.order_id', 'item_pairs.anchor_product_id', 'item_pairs.paired_product_id']) }} as basket_pair_observation_key,
    item_pairs.order_id,
    item_pairs.anchor_product_id,
    item_pairs.paired_product_id,
    item_pairs.ordered_date_utc,
    coalesce(pairings.pairing_id, 'unplanned_pair') as pairing_id,
    coalesce(pairings.pairing_reason, 'organic_pair') as pairing_reason,
    pairings.pairing_rank,
    item_pairs.anchor_item_total_major + item_pairs.paired_item_total_major as paired_item_total_major,
    coalesce(pairings.pairing_id is not null, false) as is_curated_pair
from item_pairs
left join pairings
    on
        item_pairs.anchor_product_id = pairings.anchor_product_id
        and item_pairs.paired_product_id = pairings.paired_product_id
        and cast(item_pairs.ordered_date_utc as timestamp) >= pairings.effective_from_utc
        and cast(item_pairs.ordered_date_utc as timestamp) < coalesce(pairings.effective_to_utc, cast('2999-12-31' as timestamp))
