with supplies as (
    select
        product_id,
        cast(count(*) as integer) as supply_option_count,
        min(unit_cost_major) as lowest_unit_cost_major,
        max(lead_time_days) as longest_lead_time_days,
        bool_or(perishable) as has_perishable_supply
    from {{ ref('stg_supplies') }}
    group by 1
)

select
    products.product_id,
    products.sku,
    products.product_name,
    products.category,
    products.product_family,
    products.list_price_minor,
    products.list_price_usd,
    products.catalog_currency,
    products.is_limited_time,
    products.introduced_at,
    coalesce(supplies.supply_option_count, 0) as supply_option_count,
    supplies.lowest_unit_cost_major,
    supplies.longest_lead_time_days,
    coalesce(supplies.has_perishable_supply, false) as has_perishable_supply
from {{ ref('stg_products') }} as products
left join supplies on products.product_id = supplies.product_id
