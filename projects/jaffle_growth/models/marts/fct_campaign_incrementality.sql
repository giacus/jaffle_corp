select
    {{ jaffle_shared.stable_hash(['campaign_id', 'event_date_utc', 'channel']) }} as campaign_incrementality_key,
    campaign_id,
    event_date_utc,
    channel,
    touchpoint_count,
    click_count,
    redemption_count,
    attributed_order_count,
    estimated_campaign_cost_usd,
    attributed_net_revenue_usd,
    attributed_margin_usd,
    nearby_exposure_count,
    nearby_conversion_count,
    nearby_experiment_net_revenue_usd_7d,
    heuristic_incremental_revenue_usd,
    heuristic_incremental_margin_usd,
    {{ jaffle_shared.safe_divide('heuristic_incremental_revenue_usd', 'estimated_campaign_cost_usd') }}
        as heuristic_incremental_roas
from {{ ref('int_campaign_incrementality') }}

