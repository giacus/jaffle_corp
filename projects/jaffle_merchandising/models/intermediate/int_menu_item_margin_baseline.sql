with menu_windows as (
    select * from {{ ref('int_menu_product_windows') }}
),

component_costs as (
    select
        product_id,
        sum(expected_component_cost_usd) as expected_recipe_cost_usd
    from {{ ref('jaffle_supply', 'fct_product_component_costs') }}
    group by 1
)

select
    menu_windows.menu_product_window_key as menu_item_margin_baseline_key,
    menu_windows.publication_id,
    menu_windows.store_id,
    menu_windows.product_id,
    menu_windows.product_name,
    menu_windows.product_family,
    menu_windows.country_code,
    menu_windows.currency,
    menu_windows.published_price_minor,
    menu_windows.published_price_minor / 100.0 as published_price_major,
    coalesce(component_costs.expected_recipe_cost_usd, 0) as expected_recipe_cost_usd,
    menu_windows.published_price_minor / 100.0 - coalesce(component_costs.expected_recipe_cost_usd, 0) as expected_recipe_margin_local,
    {{ jaffle_shared.safe_divide('menu_windows.published_price_minor / 100.0 - coalesce(component_costs.expected_recipe_cost_usd, 0)', 'menu_windows.published_price_minor / 100.0') }} as expected_recipe_margin_rate,
    coalesce(menu_windows.is_featured and coalesce(component_costs.expected_recipe_cost_usd, 0) = 0, false) as needs_cost_review,
    menu_windows.menu_price_band,
    menu_windows.published_at_utc,
    menu_windows.retired_at_utc,
    menu_windows.updated_at_utc
from menu_windows
left join component_costs on menu_windows.product_id = component_costs.product_id
