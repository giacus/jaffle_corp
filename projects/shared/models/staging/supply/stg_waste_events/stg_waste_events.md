{% docs supply__stg_waste_events %}
Staging model for `stg_waste_events` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_waste_events__waste_event_id %}
Source-system identifier for the waste event.
{% enddocs %}

{% docs shared__stg_waste_events__wasted_at_utc %}
UTC timestamp when wasted occurred.
{% enddocs %}

{% docs shared__stg_waste_events__wasted_date_utc %}
UTC calendar date associated with wasted.
{% enddocs %}

{% docs shared__stg_waste_events__wasted_quantity %}
Quantity of wasted recorded by the source.
{% enddocs %}

{% docs shared__stg_waste_events__reason_code %}
Normalized operational reason recorded for the component waste event.
{% enddocs %}

{% docs shared__stg_waste_events__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_waste_events` record.
{% enddocs %}
