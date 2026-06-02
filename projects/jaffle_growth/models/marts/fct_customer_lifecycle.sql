select
    {{ jaffle_shared.stable_hash(['customer_id', 'lifecycle_stage']) }} as customer_lifecycle_key,
    customer_id,
    customer_name,
    email_domain,
    loyalty_region,
    first_seen_at,
    default_currency,
    marketing_consent,
    first_ordered_at_utc,
    most_recent_ordered_at_utc,
    order_count,
    completed_order_count,
    lifetime_net_revenue_usd,
    lifetime_margin_usd,
    net_loyalty_points,
    latest_program_tier,
    lifecycle_stage,
    case
        when first_ordered_at_utc is null then null
        else date_diff('day', cast(first_seen_at as date), cast(first_ordered_at_utc as date))
    end as days_to_first_order
from {{ ref('int_customer_lifecycle_events') }}
