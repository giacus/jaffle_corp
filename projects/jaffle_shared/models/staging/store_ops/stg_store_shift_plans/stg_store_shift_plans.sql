select
    cast(shift_plan_id as varchar) as shift_plan_id,
    cast(store_id as varchar) as store_id,
    cast(shift_date as date) as shift_date,
    cast(daypart as varchar) as daypart,
    cast(planned_minutes as integer) as planned_minutes,
    cast(actual_minutes as integer) as actual_minutes,
    cast(team_member_count as integer) as team_member_count,
    cast(role_mix_code as varchar) as role_mix_code,
    cast(source_version as varchar) as source_version,
    {{ jaffle_shared.safe_divide('actual_minutes', 'planned_minutes') }} as actual_to_planned_minutes_ratio,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_store_ops_app', 'raw_store_shift_plans') }}
