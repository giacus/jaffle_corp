{% docs experience__int_ticket_sla_events %}
Intermediate model for `int_ticket_sla_events` transformation logic.
{% enddocs %}

{% docs experience__int_ticket_sla_events__first_response_sla_status %}
Derived business classification for first response SLA status on the support ticket fact with SLA and order context. Derived from first response minutes.
{% enddocs %}

{% docs experience__int_ticket_sla_events__resolution_sla_status %}
Derived business classification for resolution SLA status on the support ticket fact with SLA and order context. Derived from resolution minutes.
{% enddocs %}

{% docs experience__int_ticket_sla_events__order_total_usd %}
Order total for the support ticket fact with SLA and order context, expressed in US dollars.
{% enddocs %}

{% docs experience__int_ticket_sla_events__net_revenue_usd %}
Captured revenue minus refunded revenue for the order associated with the support ticket, expressed in US dollars.
{% enddocs %}

{% docs experience__int_ticket_sla_events__estimated_gross_margin_usd %}
Net revenue minus estimated supply cost for the order associated with the support ticket, expressed in US dollars.
{% enddocs %}

{% docs experience__int_ticket_sla_events__refund_event_count %}
Number of refund events represented by the support ticket fact with SLA and order context.
{% enddocs %}

{% docs experience__int_ticket_sla_events__has_failed_payment %}
Whether the support ticket fact with SLA and order context has failed payment.
{% enddocs %}
