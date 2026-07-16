{% docs finance__int_store_day_revenue_quality %}
Intermediate model for `int_store_day_revenue_quality` transformation logic.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__order_count %}
Number of orders represented by the finance fact for store-day revenue quality monitoring.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__net_revenue_usd %}
Captured revenue minus refunded revenue, expressed in US dollars.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__recipe_margin_usd %}
Recipe margin for the finance fact for store-day revenue quality monitoring, expressed in US dollars.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__recipe_cost_variance_usd %}
Recipe cost variance for the finance fact for store-day revenue quality monitoring, expressed in US dollars.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__refund_order_count %}
Number of refund orders represented by the finance fact for store-day revenue quality monitoring. Aggregated from refund event count.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__revenue_exception_order_count %}
Number of revenue exception orders represented by the finance fact for store-day revenue quality monitoring. Aggregated from revenue quality status.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__negative_margin_order_count %}
Number of negative margin orders represented by the finance fact for store-day revenue quality monitoring. Aggregated from recipe margin USD.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__recipe_margin_rate %}
Recipe margin rate for the finance fact for store-day revenue quality monitoring, expressed as a decimal ratio. Derived from recipe margin USD and net revenue USD.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__refund_order_rate %}
Refund order rate for the finance fact for store-day revenue quality monitoring, expressed as a decimal ratio. Derived from refund order count and order count.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__revenue_exception_rate %}
Revenue exception rate for the finance fact for store-day revenue quality monitoring, expressed as a decimal ratio. Derived from revenue exception order count and order count.
{% enddocs %}

{% docs finance__int_store_day_revenue_quality__store_day_revenue_quality_status %}
Derived business classification for store day revenue quality status on the finance fact for store-day revenue quality monitoring. Derived from negative margin order count, revenue exception order count, and recipe cost variance USD.
{% enddocs %}
