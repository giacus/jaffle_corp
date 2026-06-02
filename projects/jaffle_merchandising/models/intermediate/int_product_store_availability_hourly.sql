with availability as (
    select * from {{ ref('stg_product_availability') }}
),

menu_windows as (
    select * from {{ ref('int_menu_product_windows') }}
)

select
    {{ jaffle_shared.product_store_hour_key('availability.product_id', 'availability.store_id', "cast(availability.available_date_utc as varchar) || '-' || cast(availability.hour_local as varchar)") }} as product_store_hour_key,
    availability.availability_id,
    availability.store_id,
    availability.product_id,
    availability.available_date_utc,
    cast(availability.available_date_utc + availability.hour_local * interval '1 hour' as timestamp) as availability_hour_utc,
    availability.hour_local,
    availability.availability_status,
    availability.observed_on_hand_units,
    availability.expected_menu_units,
    availability.outage_minutes,
    {{ jaffle_shared.availability_health('availability.availability_status', 'availability.expected_menu_units', 'availability.observed_on_hand_units') }} as availability_health,
    case when availability.availability_status = 'available' then 1 else 0 end as available_hour_count,
    case when availability.availability_status in ('limited', 'unavailable') then 1 else 0 end as constrained_hour_count,
    case when availability.availability_status = 'unavailable' then 1 else 0 end as unavailable_hour_count,
    menu_windows.publication_id,
    menu_windows.menu_section,
    menu_windows.menu_surface,
    menu_windows.menu_price_band,
    menu_windows.product_family,
    menu_windows.country_code,
    menu_windows.city,
    availability.updated_at_utc
from availability
left join menu_windows
    on
        availability.store_id = menu_windows.store_id
        and availability.product_id = menu_windows.product_id
        and cast(availability.available_date_utc + availability.hour_local * interval '1 hour' as timestamp)
        >= menu_windows.published_at_utc
        and cast(availability.available_date_utc + availability.hour_local * interval '1 hour' as timestamp)
        < menu_windows.effective_to_utc
