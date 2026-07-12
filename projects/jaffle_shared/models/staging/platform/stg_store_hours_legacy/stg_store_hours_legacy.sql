select
    cast(store_id as varchar) as store_id,
    cast(legacy_hours_blob as varchar) as legacy_hours_blob,
    cast(effective_from as date) as effective_from
from {{ source('jaffle_app', 'raw_store_hours_legacy') }}
