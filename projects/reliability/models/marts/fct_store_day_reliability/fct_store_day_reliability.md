{% docs reliability__fct_store_day_reliability %}
Downstream extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__store_day_reliability_key %}
Deterministic surrogate key for the extension fact joining public finance, merchandising, and planning interfaces at store-day grain. Derived from store identifier and recognized date.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__reliability_date %}
Calendar date for reliability on the extension fact joining public finance, merchandising, and planning interfaces at store-day grain. Derived from recognized date.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__scenario_name %}
Scenario name represented by the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__observed_product_count %}
Number of observed products represented by the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__observed_hour_count %}
Number of observed hours represented by the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__available_hour_count %}
Number of available hours represented by the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__constrained_hour_count %}
Number of constrained hours represented by the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__unavailable_hour_count %}
Number of unavailable hours represented by the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__outage_minutes %}
Outage minutes for the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__average_product_availability_rate %}
Average product availability rate for the extension fact joining public finance, merchandising, and planning interfaces at store-day grain, expressed as a decimal ratio. Aggregated from availability rate.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__product_availability_status %}
Derived business classification for product availability status on the extension fact joining public finance, merchandising, and planning interfaces at store-day grain. Derived from average product availability rate.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__actual_order_count %}
Number of actual orders represented by the extension fact joining public finance, merchandising, and planning interfaces at store-day grain.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__reliability_score %}
Composite zero-to-one reliability score derived from revenue, availability, and planning signals. Derived from ready target rate, average product availability rate, prediction interval hit rate, and revenue exception rate.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__reliability_status %}
Derived business classification for reliability status on the extension fact joining public finance, merchandising, and planning interfaces at store-day grain. Derived from reliability score.
{% enddocs %}

{% docs reliability__fct_store_day_reliability__needs_reliability_review %}
Whether the extension fact joining public finance, merchandising, and planning interfaces at store-day grain requires reliability review. Derived from reliability score.
{% enddocs %}
