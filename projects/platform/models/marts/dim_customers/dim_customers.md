{% docs jaffle_platform__dim_customers %}
Customer dimension enriched with order lifecycle attributes.
{% enddocs %}

{% docs platform__dim_customers__lifetime_order_count %}
Number of lifetime orders represented by the customer dimension enriched with order lifecycle attributes.
{% enddocs %}

{% docs platform__dim_customers__lifetime_completed_order_count %}
Number of lifetime completed orders represented by the customer dimension enriched with order lifecycle attributes.
{% enddocs %}

{% docs platform__dim_customers__lifetime_order_value_usd %}
Lifetime order value for the customer dimension enriched with order lifecycle attributes, expressed in US dollars.
{% enddocs %}

{% docs platform__dim_customers__lifetime_refunded_order_count %}
Number of lifetime refunded orders represented by the customer dimension enriched with order lifecycle attributes.
{% enddocs %}

{% docs platform__dim_customers__lifecycle_stage %}
Derived business classification for lifecycle stage on the customer dimension enriched with order lifecycle attributes. Derived from lifetime completed order count.
{% enddocs %}
