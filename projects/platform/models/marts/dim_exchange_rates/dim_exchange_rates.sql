select
    {{ shared.stable_hash(['currency', 'rate_date']) }} as exchange_rate_key,
    currency,
    rate_date,
    usd_rate
from {{ ref('stg_fx_rates') }}
