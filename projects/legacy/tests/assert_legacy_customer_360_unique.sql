select
    cust,
    count(*) as records
from {{ ref('legacy_customer_360', version=1) }}
group by 1
having count(*) > 1
