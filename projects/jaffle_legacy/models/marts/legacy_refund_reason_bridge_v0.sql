with revenue as (
    select * from {{ ref('jaffle_finance', 'fct_order_revenue') }}
),

tickets as (
    select
        order_id,
        normalized_issue_type,
        resolution_type,
        concession_major
    from {{ ref('jaffle_experience', 'fct_support_tickets') }}
)

select
    {{ jaffle_shared.stable_hash(['revenue.order_id', 'coalesce(tickets.normalized_issue_type, revenue.revenue_quality_status)']) }}
        as old_refund_bridge_key,
    revenue.order_id as order_no,
    revenue.recognized_date as business_dt,
    revenue.revenue_quality_status as money_status,
    coalesce(tickets.normalized_issue_type, 'no_ticket') as old_reason,
    coalesce(tickets.resolution_type, 'none') as old_resolution,
    revenue.refunded_amount_usd as refund_amt_usd,
    coalesce(tickets.concession_major, 0) as make_good_amt,
    revenue.net_revenue_usd as net_amt_usd
from revenue
left join tickets on revenue.order_id = tickets.order_id

