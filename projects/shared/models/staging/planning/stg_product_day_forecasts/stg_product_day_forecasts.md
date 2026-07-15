{% docs jaffle_planning__stg_product_day_forecasts %}
Staging model for `stg_product_day_forecasts` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__forecast_id %}
Source-system identifier for the forecast.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__model_run_id %}
Source-system identifier for the model run.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__product_id %}
Source-system identifier for the sellable product.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__forecast_date_utc %}
UTC calendar date associated with forecast.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__forecasted_units %}
Number of product units forecast for the store and date.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__planned_price_minor %}
Planned price expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__scenario_name %}
Human-readable name of the planning scenario. Allowed normalized values: `base`, `stretch`.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__model_version %}
Version label of the forecasting model that produced the record.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__created_at_utc %}
UTC timestamp when created occurred.
{% enddocs %}

{% docs shared__stg_product_day_forecasts__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
