{% docs legacy__int_legacy_order_headers %}
Legacy compatibility adapter that reshapes the public order fact.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__order_no %}
The order no value produced for each `int_legacy_order_headers` row. Derived from legacy order number.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__modern_order_id %}
The modern order id value produced for each `int_legacy_order_headers` row. Derived from order id.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__cust %}
The cust value produced for each `int_legacy_order_headers` row. Derived from customer id.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__shop %}
The shop value produced for each `int_legacy_order_headers` row. Derived from store id.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__business_dt %}
UTC calendar date for business dt on each `int_legacy_order_headers` row. Derived from ordered at utc.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__old_status_bucket %}
The old status bucket value produced for each `int_legacy_order_headers` row. Derived from order status.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__money_kind %}
The money kind value produced for each `int_legacy_order_headers` row. Derived from currency.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__gross_amt %}
The gross amt value produced for each `int_legacy_order_headers` row. Derived from order total major.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__refund_amt %}
The refund amt value produced for each `int_legacy_order_headers` row. Derived from refunded amount major.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__net_amt %}
The net amt value produced for each `int_legacy_order_headers` row. Derived from captured amount major and refunded amount major.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__has_refund_flag %}
Whether the row produced by `int_legacy_order_headers` has refund flag. Derived from refund event count.
{% enddocs %}

{% docs legacy__int_legacy_order_headers__load_ts %}
UTC timestamp for load ts on each `int_legacy_order_headers` row. Derived from updated at utc.
{% enddocs %}
