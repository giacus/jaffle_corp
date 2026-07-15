with adjustments as (
    select * from {{ ref('stg_price_adjustments') }}
),

menu_windows as (
    select * from {{ ref('int_menu_product_windows') }}
)

select
    {{ jaffle_shared.stable_hash(['adjustments.price_adjustment_id', 'adjustments.store_id', 'adjustments.product_id']) }} as price_adjustment_window_key,
    adjustments.price_adjustment_id,
    adjustments.store_id,
    adjustments.product_id,
    menu_windows.product_name,
    menu_windows.product_family,
    menu_windows.country_code,
    adjustments.effective_from_utc,
    adjustments.effective_to_utc,
    adjustments.adjustment_reason,
    adjustments.adjustment_price_minor,
    menu_windows.published_price_minor,
    adjustments.adjustment_price_minor - menu_windows.published_price_minor as adjustment_delta_minor,
    {{ jaffle_shared.safe_divide('adjustments.adjustment_price_minor - menu_windows.published_price_minor', 'menu_windows.published_price_minor') }} as adjustment_delta_rate,
    adjustments.approved_by_role,
    {{ jaffle_shared.menu_price_band('adjustments.adjustment_price_minor') }} as adjustment_price_band,
    adjustments.updated_at_utc
from adjustments
left join menu_windows
    on
        adjustments.store_id = menu_windows.store_id
        and adjustments.product_id = menu_windows.product_id
        and adjustments.effective_from_utc >= menu_windows.published_at_utc
        and adjustments.effective_from_utc < menu_windows.effective_to_utc
