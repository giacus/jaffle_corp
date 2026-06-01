select
    cast(price_test_id as varchar) as price_test_id,
    cast(product_id as varchar) as product_id,
    cast(store_id as varchar) as store_id,
    cast(experiment_id as varchar) as experiment_id,
    cast(variant_id as varchar) as variant_id,
    cast(effective_from_utc as timestamp) as effective_from_utc,
    cast(effective_to_utc as timestamp) as effective_to_utc,
    cast(list_price_minor as integer) as list_price_minor,
    {{ jaffle_shared.minor_units_to_major_units('list_price_minor') }} as list_price_major,
    cast(currency as varchar) as currency,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_experience_app', 'raw_menu_price_tests') }}

