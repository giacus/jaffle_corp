with shifts as (
    select * from {{ ref('stg_store_shift_plans') }}
),

locations as (
    select
        store_id,
        country_code,
        city,
        timezone_name,
        is_dark_kitchen
    from {{ ref('jaffle_platform', 'dim_locations') }}
)

select
    shifts.shift_plan_id,
    shifts.store_id,
    locations.country_code,
    locations.city,
    locations.timezone_name,
    locations.is_dark_kitchen,
    shifts.shift_date,
    shifts.daypart,
    shifts.planned_minutes,
    shifts.actual_minutes,
    shifts.team_member_count,
    shifts.role_mix_code,
    shifts.source_version,
    shifts.actual_to_planned_minutes_ratio,
    {{ jaffle_shared.safe_divide('shifts.actual_minutes', 'shifts.team_member_count') }}
        as actual_minutes_per_team_member,
    case
        when shifts.actual_to_planned_minutes_ratio < 0.85 then 'under_plan'
        when shifts.actual_to_planned_minutes_ratio > 1.15 then 'over_plan'
        else 'near_plan'
    end as shift_adherence_status,
    shifts.updated_at_utc
from shifts
left join locations on shifts.store_id = locations.store_id

