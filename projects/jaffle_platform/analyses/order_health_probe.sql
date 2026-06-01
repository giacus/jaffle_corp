select
    ordered_date_utc,
    country_code,
    count(*) as order_count,
    sum(case when has_failed_payment then 1 else 0 end) as failed_payment_orders,
    sum(case when refund_event_count > 0 then 1 else 0 end) as refund_orders,
    sum(order_total_usd) as gross_order_amount_usd
from {{ ref('fct_orders') }}
group by 1, 2
order by 1, 2

