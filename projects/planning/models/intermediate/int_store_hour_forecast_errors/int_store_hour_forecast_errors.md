{% docs jaffle_planning__int_store_hour_forecast_errors %}
Intermediate model for `int_store_hour_forecast_errors` transformation logic.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__store_hour_forecast_accuracy_key %}
Deterministic surrogate key for the forecast accuracy fact at store-hour-scenario grain. Derived from forecast identifier, store identifier, and forecast hour UTC.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__forecast_date_utc %}
Calendar date for forecast on the forecast accuracy fact at store-hour-scenario grain. Derived from forecast hour UTC.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__actual_order_count %}
Number of actual orders represented by the forecast accuracy fact at store-hour-scenario grain.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__actual_completed_order_count %}
Number of actual completed orders represented by the forecast accuracy fact at store-hour-scenario grain.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__actual_order_total_usd %}
Actual order total for the forecast accuracy fact at store-hour-scenario grain, expressed in US dollars.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__forecast_error_orders %}
Forecast error orders represented by the forecast accuracy fact at store-hour-scenario grain. Derived from forecasted order count and actual order count.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__absolute_forecast_error_orders %}
Absolute forecast error orders represented by the forecast accuracy fact at store-hour-scenario grain. Derived from forecasted order count and actual order count.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__absolute_percentage_error_orders %}
Absolute percentage error orders represented by the forecast accuracy fact at store-hour-scenario grain. Derived from actual order count and forecasted order count.
{% enddocs %}

{% docs planning__int_store_hour_forecast_errors__actual_inside_prediction_interval %}
Actual inside prediction interval represented by the forecast accuracy fact at store-hour-scenario grain. Derived from lower bound orders, upper bound orders, and actual order count.
{% enddocs %}
