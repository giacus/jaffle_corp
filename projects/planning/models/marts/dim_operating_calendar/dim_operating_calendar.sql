select
    calendar_id,
    store_id,
    calendar_date_utc,
    day_type,
    expected_open_minutes,
    local_holiday_name,
    menu_focus,
    updated_at_utc
from {{ ref('stg_operating_calendar') }}
