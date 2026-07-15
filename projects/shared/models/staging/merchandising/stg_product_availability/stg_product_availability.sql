select
    cast(availability_id as varchar) as availability_id,
    cast(store_id as varchar) as store_id,
    cast(product_id as varchar) as product_id,
    cast(available_date_utc as date) as available_date_utc,
    cast(hour_local as integer) as hour_local,
    {{ jaffle_shared.availability_status('cast(availability_status as varchar)') }} as availability_status,
    cast(observed_on_hand_units as integer) as observed_on_hand_units,
    cast(expected_menu_units as integer) as expected_menu_units,
    cast(outage_minutes as integer) as outage_minutes,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_merchandising_app', 'raw_product_availability') }}
