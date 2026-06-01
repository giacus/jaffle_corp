select
    cast(customer_id as varchar) as customer_id,
    cast(customer_name as varchar) as customer_name,
    cast(email as varchar) as email,
    lower(split_part(email, '@', 2)) as email_domain,
    cast(loyalty_region as varchar) as loyalty_region,
    cast(first_seen_at as timestamp) as first_seen_at,
    cast(default_currency as varchar) as default_currency,
    cast(marketing_consent as boolean) as marketing_consent,
    cast(updated_at_utc as timestamp) as updated_at_utc
from {{ source('jaffle_app', 'raw_customers') }}

