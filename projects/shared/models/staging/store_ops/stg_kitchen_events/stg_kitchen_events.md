{% docs jaffle_store_ops__stg_kitchen_events %}
Staging model for `stg_kitchen_events` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_kitchen_events__kitchen_event_id %}
Source-system identifier for the kitchen event.
{% enddocs %}

{% docs shared__stg_kitchen_events__order_id %}
Source-system identifier for the order.
{% enddocs %}

{% docs shared__stg_kitchen_events__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_kitchen_events__station %}
Station recorded on the kitchen events record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_kitchen_events__kitchen_event_type %}
Normalized business classification for kitchen event type. Allowed normalized values: `prep_started`, `ready`, `received`, `served`, `unknown`.
{% enddocs %}

{% docs shared__stg_kitchen_events__raw_event_type %}
Normalized business classification for raw event type.
{% enddocs %}

{% docs shared__stg_kitchen_events__event_at_utc %}
UTC timestamp when the source event occurred.
{% enddocs %}

{% docs shared__stg_kitchen_events__event_date_utc %}
UTC calendar date on which the source event occurred.
{% enddocs %}

{% docs shared__stg_kitchen_events__batch_id %}
Source-system identifier for the batch.
{% enddocs %}

{% docs shared__stg_kitchen_events__operator_initials %}
Operator initials recorded on the kitchen events record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_kitchen_events__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
