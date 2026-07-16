{% docs jaffle_experience__fct_support_tickets %}
Public customer-support interface combining ticket lifecycle, SLA outcomes, and
available order and Finance context.

- **Grain:** one row per `support_ticket_id`.
- **Business rules:** derives first-response and resolution target flags from SLA
  statuses and enriches linked tickets with order revenue context.
- **Caveats:** an order can have multiple tickets, some tickets have no order,
  and concession amounts retain their stated currency rather than being
  normalized to USD.

A useful query relates support category, SLA performance, and satisfaction:

```sql
select normalized_issue_type, count(*) as tickets, avg(case when met_resolution_sla then 1.0 when not met_resolution_sla then 0.0 end) as resolution_sla_rate, avg(satisfaction_score) as avg_satisfaction_score
from {% raw %}{{ ref('fct_support_tickets') }}{% endraw %}
group by 1
order by tickets desc
```
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
