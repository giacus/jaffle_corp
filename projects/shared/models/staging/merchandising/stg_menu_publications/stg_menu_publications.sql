select
    cast(publication_id as varchar) as publication_id,
    cast(store_id as varchar) as store_id,
    cast(product_id as varchar) as product_id,
    cast(published_at_utc as timestamp) as published_at_utc,
    cast(nullif(cast(retired_at_utc as varchar), '') as timestamp) as retired_at_utc,
    cast(menu_section as varchar) as menu_section,
    cast(display_rank as integer) as display_rank,
    cast(is_featured as boolean) as is_featured,
    cast(published_price_minor as integer) as published_price_minor,
    cast(currency as varchar) as currency,
    cast(menu_surface as varchar) as menu_surface,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('merchandising_app', 'raw_menu_publications') }}
