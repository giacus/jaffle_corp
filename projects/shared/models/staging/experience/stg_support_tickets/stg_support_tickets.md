{% docs jaffle_experience__stg_support_tickets %}
Staging model for `stg_support_tickets` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_support_tickets__support_ticket_id %}
Source-system identifier for the support ticket.
{% enddocs %}

{% docs shared__stg_support_tickets__customer_id %}
Source-system identifier for the customer.
{% enddocs %}

{% docs shared__stg_support_tickets__order_id %}
Source-system identifier for the order.
{% enddocs %}

{% docs shared__stg_support_tickets__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_support_tickets__opened_at_utc %}
UTC timestamp when opened occurred.
{% enddocs %}

{% docs shared__stg_support_tickets__first_response_at_utc %}
UTC timestamp when first response occurred.
{% enddocs %}

{% docs shared__stg_support_tickets__resolved_at_utc %}
UTC timestamp when resolved occurred.
{% enddocs %}

{% docs shared__stg_support_tickets__opened_date_utc %}
UTC calendar date associated with opened.
{% enddocs %}

{% docs shared__stg_support_tickets__normalized_issue_type %}
Normalized business classification for normalized issue type. Allowed normalized values: `account_help`, `cold_food`, `late_pickup`, `missing_item`, `other`, `payment_question`, `wrong_item`.
{% enddocs %}

{% docs shared__stg_support_tickets__raw_issue_type %}
Normalized business classification for raw issue type.
{% enddocs %}

{% docs shared__stg_support_tickets__ticket_status %}
Normalized business classification for ticket status.
{% enddocs %}

{% docs shared__stg_support_tickets__resolution_type %}
Normalized business classification for resolution type.
{% enddocs %}

{% docs shared__stg_support_tickets__satisfaction_score %}
Customer satisfaction score recorded for the support ticket.
{% enddocs %}

{% docs shared__stg_support_tickets__concession_minor %}
Concession expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_support_tickets__concession_major %}
Concession expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_support_tickets__currency %}
ISO 4217 currency code attached to monetary values on the source record.
{% enddocs %}

{% docs shared__stg_support_tickets__first_response_minutes %}
Duration in minutes for first response.
{% enddocs %}

{% docs shared__stg_support_tickets__resolution_minutes %}
Duration in minutes for resolution.
{% enddocs %}

{% docs shared__stg_support_tickets__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
