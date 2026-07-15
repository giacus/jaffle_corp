{% docs jaffle_supply__int_purchase_order_receipts %}
Intermediate model for `int_purchase_order_receipts` transformation logic.
{% enddocs %}

{% docs supply__int_purchase_order_receipts__received_date_utc %}
Calendar date for received on the purchase-order fact with receipt quality and FX-normalized cost. Derived from received at UTC.
{% enddocs %}

{% docs supply__int_purchase_order_receipts__unit_cost_usd %}
Unit cost for the purchase-order fact with receipt quality and FX-normalized cost, expressed in US dollars. Derived from currency, unit cost major, and USD rate.
{% enddocs %}

{% docs supply__int_purchase_order_receipts__receipt_fill_rate %}
Received purchase-order quantity divided by ordered quantity, expressed from zero to one. Derived from quantity received and quantity ordered.
{% enddocs %}

{% docs supply__int_purchase_order_receipts__receipt_delay_minutes %}
Receipt delay minutes for the purchase-order fact with receipt quality and FX-normalized cost. Derived from received at UTC and expected at UTC.
{% enddocs %}

{% docs supply__int_purchase_order_receipts__is_late_receipt %}
Whether the purchase-order fact with receipt quality and FX-normalized cost represents late receipt. Derived from received at UTC and expected at UTC.
{% enddocs %}
