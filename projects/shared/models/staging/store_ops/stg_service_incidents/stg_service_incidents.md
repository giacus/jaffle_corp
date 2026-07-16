{% docs store_ops__stg_service_incidents %}
Staging model for `stg_service_incidents` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_service_incidents__incident_id %}
Source-system identifier for the incident.
{% enddocs %}

{% docs shared__stg_service_incidents__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_service_incidents__opened_at_utc %}
UTC timestamp when opened occurred.
{% enddocs %}

{% docs shared__stg_service_incidents__resolved_at_utc %}
UTC timestamp when resolved occurred.
{% enddocs %}

{% docs shared__stg_service_incidents__opened_date_utc %}
UTC calendar date associated with opened.
{% enddocs %}

{% docs shared__stg_service_incidents__incident_type %}
Normalized business classification for incident type.
{% enddocs %}

{% docs shared__stg_service_incidents__severity %}
Normalized operational severity assigned to the incident. Allowed normalized values: `high`, `low`, `medium`.
{% enddocs %}

{% docs shared__stg_service_incidents__affected_orders %}
Number of orders expected to be affected by the capacity scenario.
{% enddocs %}

{% docs shared__stg_service_incidents__notes_code %}
Normalized code summarizing the incident note category without retaining free text.
{% enddocs %}

{% docs shared__stg_service_incidents__incident_minutes %}
Duration in minutes for incident.
{% enddocs %}

{% docs shared__stg_service_incidents__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
