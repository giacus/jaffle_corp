select
    cast(payment_id as varchar) as payment_id,
    cast(order_id as varchar) as order_id,
    {{ jaffle_shared.normalize_payment_status('payment_status') }} as payment_status,
    cast(payment_status as varchar) as raw_payment_status,
    cast(payment_method as varchar) as payment_method,
    cast(authorized_at_utc as timestamp) as authorized_at_utc,
    cast(captured_at_utc as timestamp) as captured_at_utc,
    cast(amount_minor as integer) as amount_minor,
    {{ jaffle_shared.minor_units_to_major_units('amount_minor') }} as amount_major,
    cast(currency as varchar) as currency,
    cast(processor_region as varchar) as processor_region,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_app', 'raw_payments') }}
