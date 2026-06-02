with tickets as (
    select * from {{ ref('stg_support_tickets') }}
),

orders as (
    select
        order_id,
        order_status,
        channel,
        order_total_usd,
        refund_event_count,
        has_failed_payment
    from {{ ref('jaffle_platform', 'fct_orders') }}
),

revenue as (
    select
        order_id,
        net_revenue_usd,
        estimated_gross_margin_usd,
        revenue_quality_status
    from {{ ref('jaffle_finance', 'fct_order_revenue') }}
)

select
    tickets.support_ticket_id,
    tickets.customer_id,
    tickets.order_id,
    tickets.store_id,
    tickets.opened_at_utc,
    tickets.opened_date_utc,
    tickets.first_response_at_utc,
    tickets.resolved_at_utc,
    tickets.normalized_issue_type,
    tickets.raw_issue_type,
    tickets.ticket_status,
    tickets.resolution_type,
    tickets.satisfaction_score,
    tickets.concession_minor,
    tickets.concession_major,
    tickets.currency,
    tickets.first_response_minutes,
    tickets.resolution_minutes,
    {{ jaffle_shared.sla_status('tickets.first_response_minutes', var('ticket_first_response_target_minutes', 10)) }}
        as first_response_sla_status,
    {{ jaffle_shared.sla_status('tickets.resolution_minutes', var('ticket_resolution_target_minutes', 120)) }}
        as resolution_sla_status,
    orders.order_status,
    orders.channel,
    coalesce(orders.order_total_usd, 0) as order_total_usd,
    coalesce(revenue.net_revenue_usd, 0) as net_revenue_usd,
    coalesce(revenue.estimated_gross_margin_usd, 0) as estimated_gross_margin_usd,
    coalesce(orders.refund_event_count, 0) as refund_event_count,
    coalesce(orders.has_failed_payment, false) as has_failed_payment,
    revenue.revenue_quality_status,
    tickets.updated_at_utc
from tickets
left join orders on tickets.order_id = orders.order_id
left join revenue on tickets.order_id = revenue.order_id
