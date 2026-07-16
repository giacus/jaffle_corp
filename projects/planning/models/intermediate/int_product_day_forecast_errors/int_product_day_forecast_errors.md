{% docs planning__int_product_day_forecast_errors %}
Intermediate model for `int_product_day_forecast_errors` transformation logic.
{% enddocs %}

{% docs planning__int_product_day_forecast_errors__product_day_forecast_accuracy_key %}
Deterministic surrogate key for the forecast accuracy fact at store-product-day-scenario grain. Derived from scenario name, product identifier, store identifier, and forecast date UTC.
{% enddocs %}

{% docs planning__int_product_day_forecast_errors__actual_units %}
Actual units represented by the forecast accuracy fact at store-product-day-scenario grain.
{% enddocs %}

{% docs planning__int_product_day_forecast_errors__actual_item_revenue_usd %}
Actual item revenue for the forecast accuracy fact at store-product-day-scenario grain, expressed in US dollars.
{% enddocs %}

{% docs planning__int_product_day_forecast_errors__actual_order_count %}
Number of actual orders represented by the forecast accuracy fact at store-product-day-scenario grain.
{% enddocs %}

{% docs planning__int_product_day_forecast_errors__forecast_error_units %}
Forecast error units represented by the forecast accuracy fact at store-product-day-scenario grain. Derived from forecasted units and actual units.
{% enddocs %}

{% docs planning__int_product_day_forecast_errors__absolute_forecast_error_units %}
Absolute forecast error units represented by the forecast accuracy fact at store-product-day-scenario grain. Derived from forecasted units and actual units.
{% enddocs %}

{% docs planning__int_product_day_forecast_errors__absolute_percentage_error_units %}
Absolute percentage error units represented by the forecast accuracy fact at store-product-day-scenario grain. Derived from actual units and forecasted units.
{% enddocs %}
