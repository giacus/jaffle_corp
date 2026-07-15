{% docs jaffle_growth__int_customer_value_bands %}
Intermediate model for `int_customer_value_bands` transformation logic.
{% enddocs %}

{% docs growth__int_customer_value_bands__finance_order_count %}
Number of finance orders represented by the customer value segmentation fact combining growth, finance, and support signals.
{% enddocs %}

{% docs growth__int_customer_value_bands__lifetime_net_revenue_usd %}
Lifetime net revenue for the customer value segmentation fact combining growth, finance, and support signals, expressed in US dollars.
{% enddocs %}

{% docs growth__int_customer_value_bands__lifetime_recipe_margin_usd %}
Lifetime recipe margin for the customer value segmentation fact combining growth, finance, and support signals, expressed in US dollars.
{% enddocs %}

{% docs growth__int_customer_value_bands__most_recent_recognized_date %}
Calendar date for most recent recognized on the customer value segmentation fact combining growth, finance, and support signals. Aggregated from recognized date.
{% enddocs %}

{% docs growth__int_customer_value_bands__support_ticket_count %}
Number of support tickets represented by the customer value segmentation fact combining growth, finance, and support signals.
{% enddocs %}

{% docs growth__int_customer_value_bands__first_response_sla_met_count %}
Number of support tickets for the customer that met the first-response SLA.
{% enddocs %}

{% docs growth__int_customer_value_bands__concession_major %}
Concession for the customer value segmentation fact combining growth, finance, and support signals, expressed in currency major units.
{% enddocs %}

{% docs growth__int_customer_value_bands__exposure_count %}
Number of exposures represented by the customer value segmentation fact combining growth, finance, and support signals.
{% enddocs %}

{% docs growth__int_customer_value_bands__converted_exposure_count %}
Number of converted exposures represented by the customer value segmentation fact combining growth, finance, and support signals.
{% enddocs %}

{% docs growth__int_customer_value_bands__value_band %}
Derived business classification for value band on the customer value segmentation fact combining growth, finance, and support signals. Derived from lifecycle stage, lifetime recipe margin USD, lifetime net revenue USD, and finance order count.
{% enddocs %}

{% docs growth__int_customer_value_bands__care_profile %}
Care profile represented by the customer value segmentation fact combining growth, finance, and support signals. Derived from support ticket count and concession major.
{% enddocs %}
