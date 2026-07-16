{% docs store_ops__int_order_kitchen_timing %}
Intermediate model for `int_order_kitchen_timing` transformation logic.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__kitchen_received_at_utc %}
UTC timestamp for kitchen received on the order-level kitchen timing fact. Aggregated from event at UTC and kitchen event type.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__prep_started_at_utc %}
UTC timestamp for prep started on the order-level kitchen timing fact. Aggregated from event at UTC and kitchen event type.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__ready_at_utc %}
UTC timestamp for ready on the order-level kitchen timing fact. Aggregated from event at UTC and kitchen event type.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__served_at_utc %}
UTC timestamp for served on the order-level kitchen timing fact. Aggregated from event at UTC and kitchen event type.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__event_date_utc %}
Calendar date for event on the order-level kitchen timing fact.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__stations_seen %}
Stations seen represented by the order-level kitchen timing fact. Aggregated from station.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__kitchen_event_count %}
Number of kitchen events represented by the order-level kitchen timing fact.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__received_to_ready_minutes %}
Received to ready minutes for the order-level kitchen timing fact. Derived from ready at UTC and kitchen received at UTC.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__prep_to_ready_minutes %}
Prep to ready minutes for the order-level kitchen timing fact. Derived from ready at UTC and prep started at UTC.
{% enddocs %}

{% docs store_ops__int_order_kitchen_timing__ready_to_served_minutes %}
Ready to served minutes for the order-level kitchen timing fact. Derived from served at UTC and ready at UTC.
{% enddocs %}
