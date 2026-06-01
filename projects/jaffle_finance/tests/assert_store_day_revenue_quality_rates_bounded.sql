select *
from {{ ref('fct_store_day_revenue_quality') }}
where coalesce(refund_order_rate, 0) < 0
    or coalesce(refund_order_rate, 0) > 1
    or coalesce(revenue_exception_rate, 0) < 0
    or coalesce(revenue_exception_rate, 0) > 1

