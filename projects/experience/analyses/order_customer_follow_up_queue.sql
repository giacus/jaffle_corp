select
    orders.order_id,
    orders.customer_id,
    orders.ordered_at_utc,
    orders.order_status,
    follow_up_policy.follow_up_action
from {{ ref('platform', 'fct_orders') }} as orders
inner join {{ ref('order_status_follow_up_policy') }} as follow_up_policy
    on orders.order_status = follow_up_policy.order_status
where follow_up_policy.requires_customer_follow_up
order by orders.ordered_at_utc, orders.order_id
