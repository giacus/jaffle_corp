select
    cust,
    count(*) as records
from {{ ref('legacy_customer_360_v1') }}
group by 1
having count(*) > 1

