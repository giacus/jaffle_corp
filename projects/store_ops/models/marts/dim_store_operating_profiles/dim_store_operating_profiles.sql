with locations as (
    select * from {{ ref('platform', 'dim_locations') }}
),

shifts as (
    select
        store_id,
        count(distinct daypart) as daypart_count,
        avg(actual_to_planned_minutes_ratio) as average_shift_adherence_ratio,
        max(team_member_count) as peak_team_member_count,
        string_agg(distinct role_mix_code, ', ' order by role_mix_code) as observed_role_mix_codes
    from {{ ref('stg_store_shift_plans') }}
    group by 1
)

select
    locations.store_id,
    locations.store_name,
    locations.country_code,
    locations.city,
    locations.timezone_name,
    locations.operating_currency,
    locations.franchise_owner,
    locations.is_dark_kitchen,
    coalesce(shifts.daypart_count, 0) as daypart_count,
    coalesce(shifts.average_shift_adherence_ratio, 0) as average_shift_adherence_ratio,
    coalesce(shifts.peak_team_member_count, 0) as peak_team_member_count,
    shifts.observed_role_mix_codes
from locations
left join shifts on locations.store_id = shifts.store_id
