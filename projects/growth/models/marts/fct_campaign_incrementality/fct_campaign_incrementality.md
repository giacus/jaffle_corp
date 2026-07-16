{% docs growth__fct_campaign_incrementality %}
Public campaign-day fact with deliberately simple incrementality heuristics.
{% enddocs %}

{% docs growth__fct_campaign_incrementality__campaign_incrementality_key %}
Deterministic surrogate key for the campaign-day fact with deliberately simple incrementality heuristics. Derived from campaign identifier, event date UTC, and channel.
{% enddocs %}

{% docs growth__fct_campaign_incrementality__heuristic_incremental_roas %}
Heuristic incremental return on ad spend represented by the campaign-day fact with deliberately simple incrementality heuristics. Derived from heuristic incremental revenue USD and estimated campaign cost USD.
{% enddocs %}
