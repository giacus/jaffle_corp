select
    {{ shared.stable_hash(['shop', 'business_dt']) }} as legacy_store_day_key,
    shop,
    business_dt,
    money_kind,
    cast(count(*) as integer) as orders_cnt,
    sum(gross_amt) as gross_amt,
    sum(refund_amt) as refund_amt,
    sum(net_amt) as net_amt,
    cast(sum(case when old_status_bucket = 'good' then 1 else 0 end) as integer) as good_orders_cnt,
    cast(sum(case when old_status_bucket = 'bad' then 1 else 0 end) as integer) as bad_orders_cnt,
    cast(sum(case when has_refund_flag = 'Y' then 1 else 0 end) as integer) as refund_orders_cnt
from {{ ref('int_legacy_order_headers') }}
group by 1, 2, 3, 4
