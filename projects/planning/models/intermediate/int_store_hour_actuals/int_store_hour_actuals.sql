select
    orders.store_id,
    {{ shared.hour_start('orders.ordered_at_utc') }} as actual_hour_utc,
    cast(count(*) as integer) as actual_order_count,
    cast(sum(case when orders.is_completed_order then 1 else 0 end) as integer) as actual_completed_order_count,
    sum(orders.order_total_usd) as actual_order_total_usd,
    avg(service.received_to_ready_minutes) as average_received_to_ready_minutes,
    cast(sum(case when service.met_ready_target then 1 else 0 end) as integer) as ready_inside_target_count
from {{ ref('platform', 'fct_orders') }} as orders
left join {{ ref('store_ops', 'fct_order_service_times') }} as service
    on orders.order_id = service.order_id
group by 1, 2
