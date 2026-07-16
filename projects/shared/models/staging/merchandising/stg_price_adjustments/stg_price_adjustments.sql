select
    cast(price_adjustment_id as varchar) as price_adjustment_id,
    cast(store_id as varchar) as store_id,
    cast(product_id as varchar) as product_id,
    cast(effective_from_utc as timestamp) as effective_from_utc,
    cast(effective_to_utc as timestamp) as effective_to_utc,
    cast(adjustment_reason as varchar) as adjustment_reason,
    cast(adjustment_price_minor as integer) as adjustment_price_minor,
    cast(approved_by_role as varchar) as approved_by_role,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('merchandising_app', 'raw_price_adjustments') }}
