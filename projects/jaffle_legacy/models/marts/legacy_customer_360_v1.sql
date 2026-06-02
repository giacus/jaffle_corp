with customers as (
    select * from {{ ref('stg_legacy_customer_notes') }}
),

orders as (
    select
        customer_id,
        count(*) as order_cnt,
        sum(order_total_major) as gross_amt,
        sum(case when refund_event_count > 0 then 1 else 0 end) as refund_cnt,
        max(ordered_date_utc) as last_business_dt
    from {{ ref('jaffle_platform', 'fct_orders') }}
    group by 1
),

tickets as (
    select
        customer_id,
        count(*) as ticket_cnt,
        sum(concession_major) as make_good_amt
    from {{ ref('jaffle_experience', 'fct_support_tickets') }}
    group by 1
)

select
    customers.cust,
    customers.cust_name,
    customers.region_hint,
    customers.old_lifecycle_bucket,
    customers.contact_flag,
    coalesce(orders.order_cnt, 0) as order_cnt,
    coalesce(orders.gross_amt, 0) as gross_amt,
    coalesce(orders.refund_cnt, 0) as refund_cnt,
    coalesce(tickets.ticket_cnt, 0) as ticket_cnt,
    coalesce(tickets.make_good_amt, 0) as make_good_amt,
    orders.last_business_dt,
    customers.old_customer_note_blob
from customers
left join orders on customers.cust = orders.customer_id
left join tickets on customers.cust = tickets.customer_id
