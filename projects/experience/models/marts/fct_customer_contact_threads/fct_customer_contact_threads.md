{% docs experience__fct_customer_contact_threads %}
Public ticket contact-thread fact.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__contact_thread_key %}
Deterministic surrogate key for the ticket contact-thread fact. Derived from support ticket identifier.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__first_contact_at_utc %}
Earliest UTC timestamp for contact on the ticket contact-thread fact.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__most_recent_contact_at_utc %}
Most recent UTC timestamp for contact on the ticket contact-thread fact.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__contact_event_count %}
Number of contact events represented by the ticket contact-thread fact.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__total_message_count %}
Number of total messages represented by the ticket contact-thread fact.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__inbound_contact_count %}
Number of inbound contacts represented by the ticket contact-thread fact.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__outbound_contact_count %}
Number of outbound contacts represented by the ticket contact-thread fact.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__contact_channels %}
Contact channels represented by the ticket contact-thread fact. Aggregated from contact channel.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__handling_roles %}
Handling roles represented by the ticket contact-thread fact. Aggregated from handled by role.
{% enddocs %}

{% docs experience__fct_customer_contact_threads__updated_at_utc %}
UTC timestamp for updated on the ticket contact-thread fact.
{% enddocs %}
