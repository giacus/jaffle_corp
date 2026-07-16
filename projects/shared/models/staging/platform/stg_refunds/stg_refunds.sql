select
    cast(refund_id as varchar) as refund_id,
    cast(order_id as varchar) as order_id,
    cast(refund_reason as varchar) as refund_reason,
    cast(refunded_at_utc as timestamp) as refunded_at_utc,
    cast(cast(refunded_at_utc as timestamp) as date) as refunded_date_utc,
    cast(refund_amount_minor as integer) as refund_amount_minor,
    {{ shared.minor_units_to_major_units('refund_amount_minor') }} as refund_amount_major,
    cast(currency as varchar) as currency,
    cast(initiated_by as varchar) as initiated_by,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('platform_app', 'raw_refunds') }}
