select
    {{ shared.stable_hash(['store_id', 'exception_date_utc', 'scenario_name', 'exception_family']) }} as planning_exception_daily_key,
    store_id,
    exception_date_utc,
    scenario_name,
    exception_family,
    cast(exception_count as integer) as exception_count,
    case
        when exception_count >= 3 then 'high'
        when exception_count > 0 then 'watch'
        else 'clear'
    end as exception_status
from {{ ref('int_planning_exception_rollup') }}
