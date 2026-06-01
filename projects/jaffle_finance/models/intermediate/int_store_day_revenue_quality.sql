with order_margin as (
    select * from {{ ref('int_order_margin_waterfall') }}
),

store_day as (
    select
        store_id,
        recognized_date,
        country_code,
        city,
        cast(count(*) as integer) as order_count,
        sum(net_revenue_usd) as net_revenue_usd,
        sum(recipe_margin_usd) as recipe_margin_usd,
        sum(recipe_cost_variance_usd) as recipe_cost_variance_usd,
        cast(sum(case when refund_event_count > 0 then 1 else 0 end) as integer) as refund_order_count,
        cast(sum(case when revenue_quality_status <> 'recognized' then 1 else 0 end) as integer)
            as revenue_exception_order_count,
        cast(sum(case when recipe_margin_usd < 0 then 1 else 0 end) as integer) as negative_margin_order_count
    from order_margin
    group by 1, 2, 3, 4
)

select
    *,
    {{ jaffle_shared.safe_divide('recipe_margin_usd', 'net_revenue_usd') }} as recipe_margin_rate,
    {{ jaffle_shared.safe_divide('refund_order_count', 'order_count') }} as refund_order_rate,
    {{ jaffle_shared.safe_divide('revenue_exception_order_count', 'order_count') }} as revenue_exception_rate,
    case
        when negative_margin_order_count > 0 then 'negative_margin'
        when revenue_exception_order_count > 0 then 'revenue_review'
        when abs(recipe_cost_variance_usd) > 1 then 'cost_variance'
        else 'clean'
    end as store_day_revenue_quality_status
from store_day

