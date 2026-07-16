{% docs store_ops__fct_quality_events %}
Public quality-check event fact.
{% enddocs %}

{% docs store_ops__fct_quality_events__quality_event_key %}
Deterministic surrogate key for the quality-check event fact. Derived from quality check identifier.
{% enddocs %}

{% docs store_ops__fct_quality_events__has_quality_exception %}
Whether the quality-check event fact has quality exception. Derived from check result, measured value, expected min, and expected max.
{% enddocs %}
