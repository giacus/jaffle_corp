{% set governed_contribution_metric = metric('campaign_contribution_usd') %}

select
    '{{ governed_contribution_metric }}' as governed_metric_name,
    min(event_date_utc) as review_period_start,
    max(event_date_utc) as review_period_end,
    count(distinct campaign_id) as reviewed_campaign_count,
    sum(attributed_order_count) as attributed_order_count,
    sum(attributed_net_revenue_usd) as attributed_net_revenue_usd,
    sum(estimated_campaign_cost_usd) as estimated_campaign_cost_usd,
    sum(attributed_net_revenue_usd - estimated_campaign_cost_usd)
        as observed_campaign_contribution_usd
from {{ ref('fct_campaign_performance') }}
