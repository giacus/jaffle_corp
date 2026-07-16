{% docs growth__int_campaign_incrementality %}
Intermediate model for `int_campaign_incrementality` transformation logic.
{% enddocs %}

{% docs growth__int_campaign_incrementality__nearby_exposure_count %}
Number of nearby exposures represented by the campaign-day fact with deliberately simple incrementality heuristics. Derived from exposure count.
{% enddocs %}

{% docs growth__int_campaign_incrementality__nearby_conversion_count %}
Number of nearby conversions represented by the campaign-day fact with deliberately simple incrementality heuristics. Derived from conversion count.
{% enddocs %}

{% docs growth__int_campaign_incrementality__nearby_experiment_net_revenue_usd_7d %}
Experiment-attributed net revenue observed near the campaign day, expressed in US dollars and used only as a simple incrementality signal.
{% enddocs %}

{% docs growth__int_campaign_incrementality__heuristic_incremental_revenue_usd %}
Heuristic incremental revenue for the campaign-day fact with deliberately simple incrementality heuristics, expressed in US dollars. Derived from attributed net revenue USD and experiment net revenue USD 7d.
{% enddocs %}

{% docs growth__int_campaign_incrementality__heuristic_incremental_margin_usd %}
Heuristic incremental margin for the campaign-day fact with deliberately simple incrementality heuristics, expressed in US dollars. Derived from attributed margin USD and estimated campaign cost USD.
{% enddocs %}
