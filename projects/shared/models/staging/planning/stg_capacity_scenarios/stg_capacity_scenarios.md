{% docs planning__stg_capacity_scenarios %}
Staging model for `stg_capacity_scenarios` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__scenario_id %}
Source-system identifier for the scenario.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__scenario_name %}
Human-readable name of the planning scenario. Allowed normalized values: `base`, `stretch`.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__effective_from_utc %}
UTC timestamp at which the record becomes effective.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__effective_to_utc %}
UTC timestamp at which the record stops being effective; null means open-ended.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__target_orders_per_hour %}
Target orders per hour recorded on the capacity scenarios record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__target_ready_minutes %}
Duration in minutes for target ready.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__target_team_hours %}
Target team hours recorded on the capacity scenarios record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_capacity_scenarios__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
