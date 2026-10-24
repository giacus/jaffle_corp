select customer_id, sum(settled_amount) as settled_amount_total
from {{ ref('settlement_policy', 'settlement_events') }}
group by customer_id
