{% docs store_ops__fct_incident_reviews %}
Public store incident review fact.
{% enddocs %}

{% docs store_ops__fct_incident_reviews__incident_review_key %}
Deterministic surrogate key for the store incident review fact. Derived from incident identifier.
{% enddocs %}

{% docs store_ops__fct_incident_reviews__incident_duration_bucket %}
Incident duration bucket represented by the store incident review fact. Derived from incident minutes.
{% enddocs %}

{% docs store_ops__fct_incident_reviews__is_high_attention %}
Whether the store incident review fact represents high attention. Derived from severity and affected orders.
{% enddocs %}
