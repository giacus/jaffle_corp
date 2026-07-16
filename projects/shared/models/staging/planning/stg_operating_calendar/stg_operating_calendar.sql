select
    cast(calendar_id as varchar) as calendar_id,
    cast(store_id as varchar) as store_id,
    cast(calendar_date_utc as date) as calendar_date_utc,
    cast(day_type as varchar) as day_type,
    cast(expected_open_minutes as integer) as expected_open_minutes,
    nullif(cast(local_holiday_name as varchar), '') as local_holiday_name,
    cast(menu_focus as varchar) as menu_focus,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('planning_app', 'raw_operating_calendar') }}
