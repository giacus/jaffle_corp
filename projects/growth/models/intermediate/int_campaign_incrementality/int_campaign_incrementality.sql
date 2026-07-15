with campaign_performance as (
    select * from {{ ref('fct_campaign_performance') }}
),

experiment_rollups as (
    select
        exposed_date_utc,
        sum(exposure_count) as exposure_count,
        sum(conversion_count) as conversion_count,
        sum(net_revenue_usd_7d) as experiment_net_revenue_usd_7d
    from {{ ref('int_experiment_conversion_rollup') }}
    group by 1
)

select
    campaign_performance.campaign_id,
    campaign_performance.event_date_utc,
    campaign_performance.channel,
    campaign_performance.touchpoint_count,
    campaign_performance.click_count,
    campaign_performance.redemption_count,
    campaign_performance.attributed_order_count,
    campaign_performance.estimated_campaign_cost_usd,
    campaign_performance.attributed_net_revenue_usd,
    campaign_performance.attributed_margin_usd,
    coalesce(experiment_rollups.exposure_count, 0) as nearby_exposure_count,
    coalesce(experiment_rollups.conversion_count, 0) as nearby_conversion_count,
    coalesce(experiment_rollups.experiment_net_revenue_usd_7d, 0) as nearby_experiment_net_revenue_usd_7d,
    campaign_performance.attributed_net_revenue_usd
    - (coalesce(experiment_rollups.experiment_net_revenue_usd_7d, 0) * 0.25)
        as heuristic_incremental_revenue_usd,
    campaign_performance.attributed_margin_usd
    - (campaign_performance.estimated_campaign_cost_usd * 0.5)
        as heuristic_incremental_margin_usd
from campaign_performance
left join experiment_rollups
    on campaign_performance.event_date_utc = experiment_rollups.exposed_date_utc
