with menu_windows as (
    select * from {{ ref('int_menu_product_windows') }}
),

component_costs as (
    select
        product_id,
        sum(expected_component_cost_usd) as expected_recipe_cost_usd
    from {{ ref('jaffle_supply', 'fct_product_component_costs') }}
    group by 1
),

exchange_rates as (
    select
        currency,
        rate_date,
        usd_rate
    from {{ ref('jaffle_platform', 'dim_exchange_rates') }}
),

menu_windows_with_fx as (
    select
        menu_windows.*,
        exchange_rates.usd_rate,
        row_number() over (
            partition by menu_windows.menu_product_window_key
            order by exchange_rates.rate_date desc
        ) as fx_rate_rank
    from menu_windows
    left join exchange_rates
        on
            menu_windows.currency = exchange_rates.currency
            and exchange_rates.rate_date <= cast(menu_windows.published_at_utc as date)
)

select
    menu_windows_with_fx.menu_product_window_key as menu_item_margin_baseline_key,
    menu_windows_with_fx.publication_id,
    menu_windows_with_fx.store_id,
    menu_windows_with_fx.product_id,
    menu_windows_with_fx.product_name,
    menu_windows_with_fx.product_family,
    menu_windows_with_fx.country_code,
    menu_windows_with_fx.currency,
    menu_windows_with_fx.published_price_minor,
    menu_windows_with_fx.published_price_minor / 100.0 as published_price_major,
    menu_windows_with_fx.published_price_minor / 100.0 * menu_windows_with_fx.usd_rate as published_price_usd,
    menu_windows_with_fx.usd_rate,
    coalesce(component_costs.expected_recipe_cost_usd, 0) as expected_recipe_cost_usd,
    (
        menu_windows_with_fx.published_price_minor / 100.0 * menu_windows_with_fx.usd_rate
        - coalesce(component_costs.expected_recipe_cost_usd, 0)
    ) as expected_recipe_margin_usd,
    {{ jaffle_shared.safe_divide('menu_windows_with_fx.published_price_minor / 100.0 * menu_windows_with_fx.usd_rate - coalesce(component_costs.expected_recipe_cost_usd, 0)', 'menu_windows_with_fx.published_price_minor / 100.0 * menu_windows_with_fx.usd_rate') }} as expected_recipe_margin_rate,
    coalesce(menu_windows_with_fx.is_featured and coalesce(component_costs.expected_recipe_cost_usd, 0) = 0, false) as needs_cost_review,
    menu_windows_with_fx.menu_price_band,
    menu_windows_with_fx.published_at_utc,
    menu_windows_with_fx.retired_at_utc,
    menu_windows_with_fx.updated_at_utc
from menu_windows_with_fx
left join component_costs on menu_windows_with_fx.product_id = component_costs.product_id
where menu_windows_with_fx.fx_rate_rank = 1
