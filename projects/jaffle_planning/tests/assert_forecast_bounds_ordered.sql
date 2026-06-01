select *
from {{ ref('fct_store_hour_forecast_accuracy') }}
where lower_bound_orders > forecasted_order_count
    or forecasted_order_count > upper_bound_orders
