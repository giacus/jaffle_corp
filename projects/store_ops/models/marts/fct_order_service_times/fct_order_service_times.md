{% docs jaffle_store_ops__fct_order_service_times %}
Public order-level kitchen timing fact.
{% enddocs %}

{% docs store_ops__fct_order_service_times__order_service_time_key %}
Deterministic surrogate key for the order-level kitchen timing fact. Derived from order identifier and store identifier.
{% enddocs %}

{% docs store_ops__fct_order_service_times__received_to_ready_bucket %}
Received to ready bucket represented by the order-level kitchen timing fact. Derived from received to ready minutes.
{% enddocs %}

{% docs store_ops__fct_order_service_times__met_ready_target %}
Whether ready target was met for the order-level kitchen timing fact. Derived from received to ready minutes.
{% enddocs %}
