{% docs platform__stg_loyalty_events %}
Staging model for `stg_loyalty_events` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_loyalty_events__loyalty_event_id %}
Source-system identifier for the loyalty event.
{% enddocs %}

{% docs shared__stg_loyalty_events__event_type %}
Normalized classification of the loyalty-points event.
{% enddocs %}

{% docs shared__stg_loyalty_events__points_delta %}
Signed loyalty-point change produced by the event.
{% enddocs %}

{% docs shared__stg_loyalty_events__event_at_utc %}
UTC timestamp when the loyalty event occurred.
{% enddocs %}

{% docs shared__stg_loyalty_events__event_date_utc %}
UTC calendar date on which the loyalty event occurred.
{% enddocs %}

{% docs shared__stg_loyalty_events__program_tier %}
Normalized business classification for program tier.
{% enddocs %}

{% docs shared__stg_loyalty_events__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_loyalty_events` record.
{% enddocs %}
