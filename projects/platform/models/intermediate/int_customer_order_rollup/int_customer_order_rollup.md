{% docs platform__int_customer_order_rollup %}
Intermediate model for `int_customer_order_rollup` transformation logic.
{% enddocs %}

{% docs platform__int_customer_order_rollup__first_ordered_at_utc %}
Earliest UTC timestamp for ordered on the customer dimension enriched with order lifecycle attributes. Aggregated from ordered at UTC.
{% enddocs %}

{% docs platform__int_customer_order_rollup__most_recent_ordered_at_utc %}
Most recent UTC timestamp for ordered on the customer dimension enriched with order lifecycle attributes. Aggregated from ordered at UTC.
{% enddocs %}

{% docs platform__int_customer_order_rollup__lifetime_order_count %}
Number of lifetime order records represented by each `int_customer_order_rollup` row.
{% enddocs %}

{% docs platform__int_customer_order_rollup__lifetime_completed_order_count %}
Number of lifetime completed order records represented by each `int_customer_order_rollup` row. Derived from is completed order.
{% enddocs %}

{% docs platform__int_customer_order_rollup__lifetime_order_value_usd %}
The lifetime order value usd value produced for each `int_customer_order_rollup` row. Derived from order total usd.
{% enddocs %}

{% docs platform__int_customer_order_rollup__lifetime_refunded_order_count %}
Number of lifetime refunded order records represented by each `int_customer_order_rollup` row. Derived from refund event count.
{% enddocs %}
