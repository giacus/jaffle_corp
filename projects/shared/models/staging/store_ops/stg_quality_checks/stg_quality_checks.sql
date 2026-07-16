select
    cast(quality_check_id as varchar) as quality_check_id,
    cast(store_id as varchar) as store_id,
    cast(order_id as varchar) as order_id,
    cast(product_id as varchar) as product_id,
    cast(check_type as varchar) as check_type,
    lower(cast(check_result as varchar)) as check_result,
    cast(measured_value as double) as measured_value,
    cast(expected_min as double) as expected_min,
    cast(expected_max as double) as expected_max,
    cast(checked_at_utc as timestamp) as checked_at_utc,
    cast(cast(checked_at_utc as timestamp) as date) as checked_date_utc,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('store_ops_app', 'raw_quality_checks') }}
