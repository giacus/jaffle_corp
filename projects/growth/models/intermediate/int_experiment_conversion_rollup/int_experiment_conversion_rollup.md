{% docs growth__int_experiment_conversion_rollup %}
Intermediate model for `int_experiment_conversion_rollup` transformation logic.
{% enddocs %}

{% docs growth__int_experiment_conversion_rollup__exposure_count %}
Number of exposures represented by the experiment-day conversion fact.
{% enddocs %}

{% docs growth__int_experiment_conversion_rollup__conversion_count %}
Number of conversions represented by the experiment-day conversion fact. Aggregated from converted 7d.
{% enddocs %}

{% docs growth__int_experiment_conversion_rollup__order_count_7d %}
Number of orders measured during the 7-day attribution window for the experiment-day conversion fact.
{% enddocs %}

{% docs growth__int_experiment_conversion_rollup__net_revenue_usd_7d %}
Net revenue attributed within seven days after exposure, expressed in US dollars.
{% enddocs %}

{% docs growth__int_experiment_conversion_rollup__estimated_margin_usd_7d %}
Estimated margin attributed within seven days after exposure, expressed in US dollars.
{% enddocs %}

{% docs growth__int_experiment_conversion_rollup__conversion_rate %}
Share of eligible exposures or touchpoints that converted, expressed from zero to one. Aggregated from converted 7d.
{% enddocs %}
