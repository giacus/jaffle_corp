select *
from {{ ref('fct_order_service_times') }}
where ready_at_utc is not null
    and kitchen_received_at_utc is not null
    and ready_at_utc < kitchen_received_at_utc

