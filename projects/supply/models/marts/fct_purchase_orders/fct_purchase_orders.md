{% docs jaffle_supply__fct_purchase_orders %}
Public purchase-order fact with receipt quality and FX-normalized cost.
{% enddocs %}

{% docs supply__fct_purchase_orders__purchase_order_key %}
Deterministic surrogate key for the purchase-order fact with receipt quality and FX-normalized cost. Derived from purchase order identifier.
{% enddocs %}

{% docs supply__fct_purchase_orders__receipt_delay_bucket %}
Receipt delay bucket represented by the purchase-order fact with receipt quality and FX-normalized cost. Derived from receipt delay minutes.
{% enddocs %}
