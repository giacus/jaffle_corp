{% docs jaffle_experience__stg_customer_contacts %}
Staging model for `stg_customer_contacts` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_customer_contacts__contact_event_id %}
Source-system identifier for the contact event.
{% enddocs %}

{% docs shared__stg_customer_contacts__support_ticket_id %}
Source-system identifier for the support ticket.
{% enddocs %}

{% docs shared__stg_customer_contacts__contact_channel %}
Contact channel recorded on the customer contacts record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_customer_contacts__contact_direction %}
Contact direction recorded on the customer contacts record after type and naming normalization. Allowed normalized values: `inbound`, `outbound`.
{% enddocs %}

{% docs shared__stg_customer_contacts__contact_at_utc %}
UTC timestamp when contact occurred.
{% enddocs %}

{% docs shared__stg_customer_contacts__message_count %}
Count of message recorded by the source.
{% enddocs %}

{% docs shared__stg_customer_contacts__handled_by_role %}
Normalized business classification for handled by role.
{% enddocs %}

{% docs shared__stg_customer_contacts__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
