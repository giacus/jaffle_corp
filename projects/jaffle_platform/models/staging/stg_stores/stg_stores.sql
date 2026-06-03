select
    cast(store_id as varchar) as store_id,
    cast(store_name as varchar) as store_name,
    upper(cast(country_code as varchar)) as country_code,
    cast(city as varchar) as city,
    cast(opened_at as timestamp) as opened_at,
    cast(timezone_name as varchar) as timezone_name,
    cast(operating_currency as varchar) as operating_currency,
    cast(tax_jurisdiction as varchar) as tax_jurisdiction,
    cast(franchise_owner as varchar) as franchise_owner,
    cast(is_dark_kitchen as boolean) as is_dark_kitchen,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_app', 'raw_stores') }}
