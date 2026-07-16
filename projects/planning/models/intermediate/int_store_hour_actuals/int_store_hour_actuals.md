{% docs planning__int_store_hour_actuals %}
Intermediate model for `int_store_hour_actuals` transformation logic.
{% enddocs %}

{% docs planning__int_store_hour_actuals__actual_hour_utc %}
UTC timestamp for actual hour on each `int_store_hour_actuals` row. Derived from ordered at utc.
{% enddocs %}

{% docs planning__int_store_hour_actuals__actual_order_count %}
Number of actual order records represented by each `int_store_hour_actuals` row.
{% enddocs %}

{% docs planning__int_store_hour_actuals__actual_completed_order_count %}
Number of actual completed order records represented by each `int_store_hour_actuals` row. Derived from is completed order.
{% enddocs %}

{% docs planning__int_store_hour_actuals__actual_order_total_usd %}
The actual order total usd value produced for each `int_store_hour_actuals` row. Derived from order total usd.
{% enddocs %}

{% docs planning__int_store_hour_actuals__average_received_to_ready_minutes %}
Average received to ready minutes for the forecast accuracy fact at store-hour-scenario grain. Aggregated from received to ready minutes.
{% enddocs %}

{% docs planning__int_store_hour_actuals__ready_inside_target_count %}
Number of ready inside targets represented by the forecast accuracy fact at store-hour-scenario grain. Aggregated from met ready target.
{% enddocs %}
