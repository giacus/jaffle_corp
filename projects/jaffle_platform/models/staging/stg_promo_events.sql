select
    cast(promo_event_id as varchar) as promo_event_id,
    cast(customer_id as varchar) as customer_id,
    cast(order_id as varchar) as order_id,
    cast(campaign_id as varchar) as campaign_id,
    cast(event_type as varchar) as event_type,
    cast(event_at_utc as timestamp) as event_at_utc,
    cast(cast(event_at_utc as timestamp) as date) as event_date_utc,
    cast(channel as varchar) as channel,
    cast(cost_minor as integer) as cost_minor,
    {{ jaffle_shared.minor_units_to_major_units('cost_minor') }} as cost_major,
    cast(currency as varchar) as currency,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_app', 'raw_promo_events') }}

