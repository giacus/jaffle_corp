select
    {{ jaffle_shared.product_store_day_key('product_id', 'store_id', 'available_date_utc') }} as product_store_day_availability_key,
    store_id,
    product_id,
    available_date_utc,
    any_value(product_family) as product_family,
    any_value(menu_section) as menu_section,
    any_value(menu_surface) as menu_surface,
    any_value(country_code) as country_code,
    any_value(city) as city,
    count(*) as observed_hour_count,
    sum(available_hour_count) as available_hour_count,
    sum(constrained_hour_count) as constrained_hour_count,
    sum(unavailable_hour_count) as unavailable_hour_count,
    sum(outage_minutes) as outage_minutes,
    avg(observed_on_hand_units) as average_observed_on_hand_units,
    avg(expected_menu_units) as average_expected_menu_units,
    {{ jaffle_shared.safe_divide('sum(available_hour_count)', 'count(*)') }} as availability_rate,
    case
        when sum(unavailable_hour_count) > 0 then 'blocked'
        when sum(constrained_hour_count) > 0 then 'constrained'
        else 'healthy'
    end as product_store_day_status
from {{ ref('int_product_store_availability_hourly') }}
group by 1, 2, 3, 4
