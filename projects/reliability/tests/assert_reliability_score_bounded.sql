select *
from {{ ref('fct_store_day_reliability') }}
where reliability_score < 0 or reliability_score > 1
