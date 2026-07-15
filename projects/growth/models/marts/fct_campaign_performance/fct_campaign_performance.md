{% docs jaffle_growth__fct_campaign_performance %}
Public growth fact at one row per campaign, day, and channel.
{% enddocs %}

{% docs growth__fct_campaign_performance__campaign_performance_key %}
Deterministic surrogate key for the growth fact at one row per campaign, day, and channel. Derived from campaign identifier, event date UTC, and channel.
{% enddocs %}

{% docs growth__fct_campaign_performance__touchpoint_count %}
Number of touchpoints represented by the growth fact at one row per campaign, day, and channel.
{% enddocs %}

{% docs growth__fct_campaign_performance__click_count %}
Number of clicks represented by the growth fact at one row per campaign, day, and channel. Aggregated from event type.
{% enddocs %}

{% docs growth__fct_campaign_performance__redemption_count %}
Number of redemptions represented by the growth fact at one row per campaign, day, and channel. Aggregated from event type.
{% enddocs %}

{% docs growth__fct_campaign_performance__attributed_order_count %}
Number of attributed orders represented by the growth fact at one row per campaign, day, and channel. Aggregated from is attributed order.
{% enddocs %}

{% docs growth__fct_campaign_performance__estimated_campaign_cost_usd %}
Estimated campaign cost for the growth fact at one row per campaign, day, and channel, expressed in US dollars. Aggregated from estimated cost USD.
{% enddocs %}

{% docs growth__fct_campaign_performance__attributed_net_revenue_usd %}
Attributed net revenue for the growth fact at one row per campaign, day, and channel, expressed in US dollars. Aggregated from is attributed order and net revenue USD.
{% enddocs %}

{% docs growth__fct_campaign_performance__attributed_margin_usd %}
Attributed margin for the growth fact at one row per campaign, day, and channel, expressed in US dollars. Aggregated from is attributed order and estimated gross margin USD.
{% enddocs %}

{% docs growth__fct_campaign_performance__estimated_roas %}
Estimated return on ad spend represented by the growth fact at one row per campaign, day, and channel. Aggregated from estimated cost USD, is attributed order, and net revenue USD.
{% enddocs %}
