select
    {{ jaffle_shared.stable_hash(['business_dt', 'family', 'cat']) }} as legacy_menu_mix_key,
    business_dt,
    family,
    cat,
    count(distinct order_no) as orders_cnt,
    sum(qty) as items_qty,
    sum(item_amt) as item_amt,
    sum(supply_minor_guess) / 100.0 as supply_guess_amt,
    sum(item_amt) - (sum(supply_minor_guess) / 100.0) as margin_guess_amt
from {{ ref('stg_legacy_menu_mix') }}
group by 1, 2, 3, 4

