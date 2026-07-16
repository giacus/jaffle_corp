{% docs store_ops__fct_store_day_operations %}
Public store-day operating fact combining finance, timing, quality, supply, and incidents.
{% enddocs %}

{% docs store_ops__fct_store_day_operations__store_day_operations_key %}
Deterministic surrogate key for the store-day operating fact combining finance, timing, quality, supply, and incidents. Derived from store identifier and operating date.
{% enddocs %}

{% docs store_ops__fct_store_day_operations__ready_inside_target_count %}
Number of ready inside targets represented by the store-day operating fact combining finance, timing, quality, supply, and incidents.
{% enddocs %}

{% docs store_ops__fct_store_day_operations__ready_target_rate %}
Ready target rate for the store-day operating fact combining finance, timing, quality, supply, and incidents, expressed as a decimal ratio. Derived from order timing count and ready inside target count.
{% enddocs %}

{% docs store_ops__fct_store_day_operations__orders_per_actual_minute %}
Orders per actual minute represented by the store-day operating fact combining finance, timing, quality, supply, and incidents. Derived from order count and actual minutes.
{% enddocs %}

{% docs store_ops__fct_store_day_operations__quality_exception_rate %}
Quality exception rate for the store-day operating fact combining finance, timing, quality, supply, and incidents, expressed as a decimal ratio. Derived from quality exception count and quality check count.
{% enddocs %}

{% docs store_ops__fct_store_day_operations__supply_risk_component_rate %}
Supply risk component rate for the store-day operating fact combining finance, timing, quality, supply, and incidents, expressed as a decimal ratio. Derived from supply risk component count and component day count.
{% enddocs %}

{% docs store_ops__fct_store_day_operations__store_day_status %}
Derived business classification for store day status on the store-day operating fact combining finance, timing, quality, supply, and incidents. Derived from order timing count, supply risk component count, ready inside target count, incident count, and related inputs.
{% enddocs %}
