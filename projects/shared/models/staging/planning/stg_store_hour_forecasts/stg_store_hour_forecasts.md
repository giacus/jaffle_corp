{% docs jaffle_planning__stg_store_hour_forecasts %}
Staging model for `stg_store_hour_forecasts` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__forecast_id %}
Source-system identifier for the forecast.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__model_run_id %}
Source-system identifier for the model run.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__forecast_hour_utc %}
UTC hour associated with forecast.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__forecasted_order_count %}
Count of forecasted order recorded by the source.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__lower_bound_orders %}
Lower bound orders recorded on the store hour forecasts record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__upper_bound_orders %}
Upper bound orders recorded on the store hour forecasts record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__scenario_name %}
Human-readable name of the planning scenario. Allowed normalized values: `base`, `stretch`.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__model_version %}
Version label of the forecasting model that produced the record.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__created_at_utc %}
UTC timestamp when created occurred.
{% enddocs %}

{% docs shared__stg_store_hour_forecasts__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
