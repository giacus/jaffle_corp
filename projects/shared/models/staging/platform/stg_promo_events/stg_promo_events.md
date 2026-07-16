{% docs platform__stg_promo_events %}
Staging model for `stg_promo_events` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_promo_events__promo_event_id %}
Source-system identifier for the promo event.
{% enddocs %}

{% docs shared__stg_promo_events__customer_id %}
Source-system identifier for the customer.
{% enddocs %}

{% docs shared__stg_promo_events__order_id %}
Source-system identifier for the order.
{% enddocs %}

{% docs shared__stg_promo_events__campaign_id %}
Source-system identifier for the campaign.
{% enddocs %}

{% docs shared__stg_promo_events__event_type %}
Normalized business classification for event type.
{% enddocs %}

{% docs shared__stg_promo_events__event_at_utc %}
UTC timestamp when the source event occurred.
{% enddocs %}

{% docs shared__stg_promo_events__event_date_utc %}
UTC calendar date on which the source event occurred.
{% enddocs %}

{% docs shared__stg_promo_events__channel %}
Normalized acquisition or ordering channel recorded by the source.
{% enddocs %}

{% docs shared__stg_promo_events__cost_minor %}
Cost expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_promo_events__cost_major %}
Cost expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_promo_events__currency %}
ISO 4217 currency code attached to monetary values on the source record.
{% enddocs %}

{% docs shared__stg_promo_events__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
