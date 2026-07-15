{% docs jaffle_growth__int_campaign_touchpoints %}
Intermediate model for `int_campaign_touchpoints` transformation logic.
{% enddocs %}

{% docs growth__int_campaign_touchpoints__estimated_cost_usd %}
The estimated cost usd value produced for each `int_campaign_touchpoints` row. Derived from cost major, order total major, and order total usd.
{% enddocs %}

{% docs growth__int_campaign_touchpoints__is_completed_order %}
Whether completed order is true for the row produced by `int_campaign_touchpoints`.
{% enddocs %}

{% docs growth__int_campaign_touchpoints__is_attributed_order %}
Whether attributed order is true for the row produced by `int_campaign_touchpoints`. Derived from is completed order and event type.
{% enddocs %}
