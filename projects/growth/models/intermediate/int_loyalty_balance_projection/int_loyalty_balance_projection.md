{% docs jaffle_growth__int_loyalty_balance_projection %}
Intermediate model for `int_loyalty_balance_projection` transformation logic.
{% enddocs %}

{% docs growth__int_loyalty_balance_projection__points_delta %}
Points delta represented by the customer-day loyalty balance projection.
{% enddocs %}

{% docs growth__int_loyalty_balance_projection__projected_points_balance %}
Projected points balance represented by the customer-day loyalty balance projection. Aggregated from customer identifier, points delta, and event date UTC.
{% enddocs %}

{% docs growth__int_loyalty_balance_projection__latest_program_tier %}
Derived business classification for latest program tier on the customer-day loyalty balance projection. Aggregated from program tier.
{% enddocs %}

{% docs growth__int_loyalty_balance_projection__loyalty_event_count %}
Number of loyalty events represented by the customer-day loyalty balance projection.
{% enddocs %}

{% docs growth__int_loyalty_balance_projection__loyalty_balance_status %}
Derived business classification for loyalty balance status on the customer-day loyalty balance projection. Aggregated from latest program tier, customer identifier, points delta, and event date UTC.
{% enddocs %}
