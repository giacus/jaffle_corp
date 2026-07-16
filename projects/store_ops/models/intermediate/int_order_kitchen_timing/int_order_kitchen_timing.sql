with kitchen_events as (
    select * from {{ ref('stg_kitchen_events') }}
),

event_pivot as (
    select
        order_id,
        store_id,
        min(case when kitchen_event_type = 'received' then event_at_utc end) as kitchen_received_at_utc,
        min(case when kitchen_event_type = 'prep_started' then event_at_utc end) as prep_started_at_utc,
        min(case when kitchen_event_type = 'ready' then event_at_utc end) as ready_at_utc,
        min(case when kitchen_event_type = 'served' then event_at_utc end) as served_at_utc,
        min(event_date_utc) as event_date_utc,
        string_agg(distinct station, ', ' order by station) as stations_seen,
        cast(count(*) as integer) as kitchen_event_count
    from kitchen_events
    group by 1, 2
),

orders as (
    select
        order_id,
        customer_id,
        ordered_at_utc,
        ordered_date_utc,
        order_status,
        is_completed_order
    from {{ ref('platform', 'fct_orders') }}
)

select
    event_pivot.order_id,
    event_pivot.store_id,
    orders.customer_id,
    orders.ordered_at_utc,
    orders.ordered_date_utc,
    orders.order_status,
    orders.is_completed_order,
    event_pivot.kitchen_received_at_utc,
    event_pivot.prep_started_at_utc,
    event_pivot.ready_at_utc,
    event_pivot.served_at_utc,
    event_pivot.event_date_utc,
    event_pivot.stations_seen,
    event_pivot.kitchen_event_count,
    {{ shared.minutes_between('event_pivot.kitchen_received_at_utc', 'event_pivot.ready_at_utc') }}
        as received_to_ready_minutes,
    {{ shared.minutes_between('event_pivot.prep_started_at_utc', 'event_pivot.ready_at_utc') }}
        as prep_to_ready_minutes,
    {{ shared.minutes_between('event_pivot.ready_at_utc', 'event_pivot.served_at_utc') }}
        as ready_to_served_minutes
from event_pivot
left join orders on event_pivot.order_id = orders.order_id
