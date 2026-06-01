select *
from {{ ref('fct_customer_value_segments') }}
where value_band is null or care_profile is null

