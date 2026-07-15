select *
from {{ ref('fct_store_day_capacity_plan') }}
where
    forecasted_orders_per_open_hour < 0
    or actual_orders_per_open_hour < 0
