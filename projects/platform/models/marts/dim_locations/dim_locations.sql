select
    stores.store_id,
    stores.store_name,
    stores.country_code,
    stores.city,
    stores.opened_at,
    stores.timezone_name,
    stores.operating_currency,
    stores.tax_jurisdiction,
    stores.franchise_owner,
    stores.is_dark_kitchen,
    legacy.legacy_hours_blob,
    legacy.effective_from as legacy_hours_effective_from
from {{ ref('stg_stores') }} as stores
left join {{ ref('stg_store_hours_legacy') }} as legacy
    on stores.store_id = legacy.store_id
