{% docs platform__int_orders_enriched %}
Intermediate model for `int_orders_enriched` transformation logic.
{% enddocs %}

{% docs platform__int_orders_enriched__order_total_usd %}
Order total for the order fact at one row per order, expressed in US dollars. Derived from currency, order total major, and USD rate.
{% enddocs %}

{% docs platform__int_orders_enriched__captured_amount_minor %}
Sum of successfully captured payment attempts for the order, expressed in currency minor units and zero-filled when none exist.
{% enddocs %}

{% docs platform__int_orders_enriched__captured_amount_major %}
Captured amount for the order fact at one row per order, expressed in currency major units. Derived from captured amount minor.
{% enddocs %}

{% docs platform__int_orders_enriched__refunded_amount_minor %}
Sum of refund events for the order, expressed in currency minor units and zero-filled when none exist.
{% enddocs %}

{% docs platform__int_orders_enriched__refunded_amount_major %}
Refunded amount for the order fact at one row per order, expressed in currency major units. Derived from refunded amount minor.
{% enddocs %}

{% docs platform__int_orders_enriched__payment_attempt_count %}
Number of payment attempts represented by the order fact at one row per order.
{% enddocs %}

{% docs platform__int_orders_enriched__refund_event_count %}
Number of refund events represented by the order fact at one row per order.
{% enddocs %}

{% docs platform__int_orders_enriched__has_failed_payment %}
Whether the order fact at one row per order has failed payment.
{% enddocs %}

{% docs platform__int_orders_enriched__is_completed_order %}
Whether the order reached the normalized `completed` lifecycle status.
{% enddocs %}

{% docs platform__int_orders_enriched__is_cancelled_order %}
Whether the order reached the normalized `cancelled` lifecycle status.
{% enddocs %}
