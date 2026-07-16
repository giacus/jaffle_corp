select
    locations.store_id as shop,
    locations.store_name as shop_nm,
    locations.country_code as cntry,
    locations.city as city_nm,
    locations.operating_currency as local_money_kind,
    locations.legacy_hours_blob as hours_txt,
    case
        when locations.is_dark_kitchen then 'hidden'
        else 'walkup'
    end as shop_kind,
    products.product_id as item,
    products.sku as item_sku,
    products.product_family as item_family
from {{ ref('platform', 'dim_locations') }} as locations
cross join {{ ref('platform', 'dim_products') }} as products
