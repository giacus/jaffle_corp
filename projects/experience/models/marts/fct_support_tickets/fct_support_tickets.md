{% docs jaffle_experience__fct_support_tickets %}
Public support ticket fact with SLA and order context.
{% enddocs %}

{% docs experience__fct_support_tickets__support_ticket_key %}
Deterministic surrogate key for the support ticket fact with SLA and order context. Derived from support ticket identifier.
{% enddocs %}

{% docs experience__fct_support_tickets__met_first_response_sla %}
Whether first response SLA was met for the support ticket fact with SLA and order context. Derived from first response SLA status.
{% enddocs %}

{% docs experience__fct_support_tickets__met_resolution_sla %}
Whether resolution SLA was met for the support ticket fact with SLA and order context. Derived from resolution SLA status.
{% enddocs %}
