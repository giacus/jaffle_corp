select
    cast(exposure_id as varchar) as exposure_id,
    cast(customer_id as varchar) as customer_id,
    cast(experiment_id as varchar) as experiment_id,
    cast(variant_id as varchar) as variant_id,
    cast(exposed_at_utc as timestamp) as exposed_at_utc,
    cast(cast(exposed_at_utc as timestamp) as date) as exposed_date_utc,
    cast(surface as varchar) as surface,
    cast(assignment_reason as varchar) as assignment_reason,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('experience_app', 'raw_experiment_exposures') }}
