select *
from {{ ref('fct_purchase_orders') }}
where receipt_fill_rate < 0 or receipt_fill_rate > 1.05

