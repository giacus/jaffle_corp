select
    customer_id as cust,
    customer_name as cust_name,
    loyalty_region as region_hint,
    lifecycle_stage as old_lifecycle_bucket,
    case
        when marketing_consent then 'ok_to_email'
        else 'do_not_email'
    end as contact_flag,
    concat(customer_id, '|', lifecycle_stage, '|', loyalty_region) as old_customer_note_blob
from {{ ref('platform', 'dim_customers') }}
