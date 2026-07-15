{% docs jaffle_growth__int_customer_lifecycle_events %}
Intermediate model for `int_customer_lifecycle_events` transformation logic.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__first_ordered_at_utc %}
Earliest UTC timestamp for ordered on the growth fact at one row per customer lifecycle state. Aggregated from ordered at UTC.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__most_recent_ordered_at_utc %}
Most recent UTC timestamp for ordered on the growth fact at one row per customer lifecycle state. Aggregated from ordered at UTC.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__order_count %}
Number of orders represented by the growth fact at one row per customer lifecycle state.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__completed_order_count %}
Number of completed orders represented by the growth fact at one row per customer lifecycle state.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__lifetime_net_revenue_usd %}
Lifetime net revenue for the growth fact at one row per customer lifecycle state, expressed in US dollars.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__lifetime_margin_usd %}
Lifetime margin for the growth fact at one row per customer lifecycle state, expressed in US dollars.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__net_loyalty_points %}
Net loyalty points represented by the growth fact at one row per customer lifecycle state.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__latest_program_tier %}
Derived business classification for latest program tier on the growth fact at one row per customer lifecycle state.
{% enddocs %}

{% docs growth__int_customer_lifecycle_events__lifecycle_stage %}
Derived business classification for lifecycle stage on the growth fact at one row per customer lifecycle state. Derived from marketing consent and completed order count.
{% enddocs %}
