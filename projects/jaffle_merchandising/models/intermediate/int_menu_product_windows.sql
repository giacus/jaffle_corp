with publications as (
    select * from {{ ref('stg_menu_publications') }}
),

products as (
    select * from {{ ref('dim_products') }}
),

locations as (
    select * from {{ ref('dim_locations') }}
)

select
    {{ jaffle_shared.stable_hash(['publications.publication_id', 'publications.store_id', 'publications.product_id']) }} as menu_product_window_key,
    publications.publication_id,
    publications.store_id,
    locations.country_code,
    locations.city,
    publications.product_id,
    products.sku,
    products.product_name,
    products.category,
    products.product_family,
    publications.published_at_utc,
    publications.retired_at_utc,
    coalesce(publications.retired_at_utc, cast('2999-12-31' as timestamp)) as effective_to_utc,
    publications.menu_section,
    publications.display_rank,
    publications.is_featured,
    publications.published_price_minor,
    publications.currency,
    publications.menu_surface,
    {{ jaffle_shared.menu_price_band('publications.published_price_minor') }} as menu_price_band,
    products.is_limited_time,
    products.has_perishable_supply,
    publications.updated_at_utc
from publications
left join products on publications.product_id = products.product_id
left join locations on publications.store_id = locations.store_id
