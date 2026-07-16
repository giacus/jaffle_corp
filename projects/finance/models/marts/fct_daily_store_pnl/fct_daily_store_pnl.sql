select
    {{ shared.stable_hash(['store_id', 'recognized_date']) }} as store_pnl_key,
    store_id,
    recognized_date,
    country_code,
    city,
    franchise_owner,
    cast(count(*) as integer) as order_count,
    sum(gross_revenue_usd) as gross_revenue_usd,
    sum(net_revenue_usd) as net_revenue_usd,
    sum(refunded_amount_usd) as refunded_amount_usd,
    sum(estimated_supply_cost_usd) as estimated_supply_cost_usd,
    sum(estimated_gross_margin_usd) as estimated_gross_margin_usd,
    cast(sum(order_item_count) as integer) as order_item_count,
    cast(sum(total_item_quantity) as integer) as total_item_quantity,
    cast(sum(case when revenue_quality_status = 'payment_risk' then 1 else 0 end) as integer)
        as payment_risk_order_count
from {{ ref('fct_order_revenue') }}
group by 1, 2, 3, 4, 5, 6
