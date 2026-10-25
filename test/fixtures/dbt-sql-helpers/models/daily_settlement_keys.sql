select
    {{ dbt.date_trunc('day', 'settled_at') }} as settlement_day,
    {{ dbt.hash("cast(settlement_id as " ~ dbt.type_string() ~ ")") }} as settlement_key
from {{ ref('settlement_events') }}
