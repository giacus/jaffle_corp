with current_customers as (
    select
        customer_id,
        updated_at_utc
    from {{ ref('dim_customers') }}
),

customer_history as (
    select
        customer_id,
        count(*) as recorded_version_count,
        max(dbt_valid_from) as latest_recorded_at
    from {{ ref('customer_profile_snapshot') }}
    group by customer_id
)

select
    current_customers.customer_id,
    current_customers.updated_at_utc,
    coalesce(customer_history.recorded_version_count, 0) as recorded_version_count,
    customer_history.latest_recorded_at
from current_customers
left join customer_history
    on current_customers.customer_id = customer_history.customer_id
order by current_customers.customer_id
