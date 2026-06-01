select
    {{ jaffle_shared.stable_hash(['campaign_id', 'event_date_utc', 'channel']) }} as campaign_performance_key,
    campaign_id,
    event_date_utc,
    channel,
    cast(count(*) as integer) as touchpoint_count,
    cast(sum(case when event_type = 'clicked' then 1 else 0 end) as integer) as click_count,
    cast(sum(case when event_type = 'redeemed' then 1 else 0 end) as integer) as redemption_count,
    cast(sum(case when is_attributed_order then 1 else 0 end) as integer) as attributed_order_count,
    sum(coalesce(estimated_cost_usd, 0)) as estimated_campaign_cost_usd,
    sum(case when is_attributed_order then coalesce(net_revenue_usd, 0) else 0 end)
        as attributed_net_revenue_usd,
    sum(case when is_attributed_order then coalesce(estimated_gross_margin_usd, 0) else 0 end)
        as attributed_margin_usd,
    case
        when sum(coalesce(estimated_cost_usd, 0)) = 0 then null
        else sum(case when is_attributed_order then coalesce(net_revenue_usd, 0) else 0 end)
            / sum(coalesce(estimated_cost_usd, 0))
    end as estimated_roas
from {{ ref('int_campaign_touchpoints') }}
group by 1, 2, 3, 4

