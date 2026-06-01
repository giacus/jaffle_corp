{{ config(tags=['product_store_grain']) }}

select
    product_store_hour_key,
    availability_id,
    store_id,
    product_id,
    available_date_utc,
    availability_hour_utc,
    hour_local,
    availability_status,
    observed_on_hand_units,
    expected_menu_units,
    outage_minutes,
    availability_health,
    available_hour_count,
    constrained_hour_count,
    unavailable_hour_count,
    publication_id,
    menu_section,
    menu_surface,
    menu_price_band,
    product_family,
    country_code,
    city,
    updated_at_utc
from {{ ref('int_product_store_availability_hourly') }}
