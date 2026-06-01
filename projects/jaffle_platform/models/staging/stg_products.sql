select
    cast(product_id as varchar) as product_id,
    cast(sku as varchar) as sku,
    cast(product_name as varchar) as product_name,
    cast(category as varchar) as category,
    cast(product_family as varchar) as product_family,
    cast(list_price_minor as integer) as list_price_minor,
    {{ jaffle_shared.minor_units_to_major_units('list_price_minor') }} as list_price_usd,
    cast(currency as varchar) as catalog_currency,
    cast(is_limited_time as boolean) as is_limited_time,
    cast(introduced_at as timestamp) as introduced_at,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_app', 'raw_products') }}

