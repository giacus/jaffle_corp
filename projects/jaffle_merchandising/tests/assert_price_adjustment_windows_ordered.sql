select *
from {{ ref('fct_price_adjustment_windows') }}
where effective_to_utc <= effective_from_utc
