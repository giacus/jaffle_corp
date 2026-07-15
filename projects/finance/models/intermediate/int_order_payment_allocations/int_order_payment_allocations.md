{% docs jaffle_finance__int_order_payment_allocations %}
Intermediate model for `int_order_payment_allocations` transformation logic.
{% enddocs %}

{% docs finance__int_order_payment_allocations__order_id %}
Identifier of the order represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__customer_id %}
Identifier of the customer represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__store_id %}
Identifier of the store represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__ordered_at_utc %}
UTC timestamp for ordered on the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__ordered_date_utc %}
UTC calendar date for ordered on each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__order_status %}
Derived business classification for order status on the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__channel %}
Channel represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__currency %}
Currency represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__country_code %}
Country code represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__city %}
City represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__tax_jurisdiction %}
Tax jurisdiction represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__franchise_owner %}
Franchise owner represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__subtotal_minor %}
The subtotal minor value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__tax_minor %}
The tax minor value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__discount_minor %}
The discount minor value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__service_fee_minor %}
The service fee minor value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__order_total_minor %}
The order total minor value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__order_total_major %}
The order total major value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__order_total_usd %}
The order total usd value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__captured_amount_major %}
The captured amount major value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__captured_amount_usd %}
Successfully captured payment amount expressed in US dollars. Derived from captured amount major and USD per order currency unit.
{% enddocs %}

{% docs finance__int_order_payment_allocations__refunded_amount_major %}
The refunded amount major value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__refunded_amount_usd %}
Refunded payment amount expressed in US dollars. Derived from refunded amount major and USD per order currency unit.
{% enddocs %}

{% docs finance__int_order_payment_allocations__payment_attempt_count %}
Number of payment attempts represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__refund_event_count %}
Number of refund events represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__has_failed_payment %}
Whether the row produced by `int_order_payment_allocations` has failed payment.
{% enddocs %}

{% docs finance__int_order_payment_allocations__is_completed_order %}
Whether completed order is true for the row produced by `int_order_payment_allocations`.
{% enddocs %}

{% docs finance__int_order_payment_allocations__is_cancelled_order %}
Whether cancelled order is true for the row produced by `int_order_payment_allocations`.
{% enddocs %}

{% docs finance__int_order_payment_allocations__revenue_quality_status %}
Derived business classification for revenue quality status on the finance fact at one row per order. Derived from has failed payment, is cancelled order, is completed order, and refund event count.
{% enddocs %}
