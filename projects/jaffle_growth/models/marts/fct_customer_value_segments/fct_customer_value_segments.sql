select
    {{ jaffle_shared.stable_hash(['customer_id', 'value_band', 'care_profile']) }} as customer_value_segment_key,
    customer_id,
    customer_name,
    loyalty_region,
    lifecycle_stage,
    marketing_consent,
    finance_order_count,
    lifetime_net_revenue_usd,
    lifetime_recipe_margin_usd,
    most_recent_recognized_date,
    support_ticket_count,
    first_response_sla_met_count,
    concession_major,
    exposure_count,
    converted_exposure_count,
    value_band,
    care_profile
from {{ ref('int_customer_value_bands') }}
