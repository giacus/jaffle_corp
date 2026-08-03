{% docs legacy__legacy_customer_360 %}
Versioned customer migration interface with mixed behavioral and support columns. Version 2 excludes cancelled orders from its activity and gross-amount measures while version 1 preserves the original contract for pinned consumers.
{% enddocs %}

{% docs legacy__legacy_customer_360_v1__order_cnt %}
The original order count produced for each v1 legacy customer row, including cancelled orders.
{% enddocs %}

{% docs legacy__legacy_customer_360_v1__gross_amt %}
The original gross amount produced for each v1 legacy customer row, including cancelled orders.
{% enddocs %}

{% docs legacy__legacy_customer_360_v1__refund_cnt %}
The refund count produced for each v1 legacy customer row.
{% enddocs %}

{% docs legacy__legacy_customer_360_v1__ticket_cnt %}
The support ticket count produced for each v1 legacy customer row.
{% enddocs %}

{% docs legacy__legacy_customer_360_v1__make_good_amt %}
The customer concession amount produced for each v1 legacy customer row.
{% enddocs %}

{% docs legacy__legacy_customer_360_v1__last_business_dt %}
UTC calendar date of the latest order for each v1 legacy customer row, including cancelled orders.
{% enddocs %}
