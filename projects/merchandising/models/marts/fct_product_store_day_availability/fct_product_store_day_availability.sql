{{ config(tags=['product_store_grain']) }}

select
    product_store_day_availability_key,
    store_id,
    product_id,
    available_date_utc,
    product_family,
    menu_section,
    menu_surface,
    country_code,
    city,
    cast(observed_hour_count as integer) as observed_hour_count,
    cast(available_hour_count as integer) as available_hour_count,
    cast(constrained_hour_count as integer) as constrained_hour_count,
    cast(unavailable_hour_count as integer) as unavailable_hour_count,
    cast(outage_minutes as integer) as outage_minutes,
    average_observed_on_hand_units,
    average_expected_menu_units,
    availability_rate,
    product_store_day_status
from {{ ref('int_product_store_day_availability') }}
