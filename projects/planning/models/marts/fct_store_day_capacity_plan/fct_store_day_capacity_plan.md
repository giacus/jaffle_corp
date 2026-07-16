{% docs planning__fct_store_day_capacity_plan %}
Public store-day scenario plan fact that blends forecasts, calendar, operations, and finance actuals.
{% enddocs %}

{% docs planning__fct_store_day_capacity_plan__forecasted_orders_per_open_hour %}
Forecasted orders per open hour represented by the store-day scenario plan fact that blends forecasts, calendar, operations, and finance actuals. Derived from forecasted order count and expected open minutes.
{% enddocs %}

{% docs planning__fct_store_day_capacity_plan__actual_orders_per_open_hour %}
Actual orders per open hour represented by the store-day scenario plan fact that blends forecasts, calendar, operations, and finance actuals. Derived from actual order count and expected open minutes.
{% enddocs %}

{% docs planning__fct_store_day_capacity_plan__prediction_interval_hit_rate %}
Share of forecasts whose actual value falls inside the prediction interval. Derived from inside interval hour count and forecast hour count.
{% enddocs %}
