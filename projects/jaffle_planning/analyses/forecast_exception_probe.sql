select
    store_id,
    forecast_date_utc,
    scenario_name,
    forecast_accuracy_band,
    count(*) as forecast_row_count,
    sum(absolute_forecast_error_orders) as absolute_forecast_error_orders
from {{ ref('fct_store_hour_forecast_accuracy') }}
group by 1, 2, 3, 4
order by forecast_date_utc, store_id, scenario_name
