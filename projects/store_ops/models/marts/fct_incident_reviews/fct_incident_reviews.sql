select
    {{ shared.stable_hash(['incident_id']) }} as incident_review_key,
    incident_id,
    store_id,
    opened_at_utc,
    resolved_at_utc,
    opened_date_utc,
    incident_type,
    severity,
    affected_orders,
    notes_code,
    incident_minutes,
    {{ shared.bucket_minutes('incident_minutes') }} as incident_duration_bucket,
    severity = 'high' or affected_orders > 1 as is_high_attention,
    updated_at_utc
from {{ ref('stg_service_incidents') }}
