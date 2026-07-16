select
    cast(currency as varchar) as currency,
    cast(rate_date as date) as rate_date,
    cast(usd_rate as double) as usd_rate
from {{ source('platform_app', 'raw_fx_rates') }}
