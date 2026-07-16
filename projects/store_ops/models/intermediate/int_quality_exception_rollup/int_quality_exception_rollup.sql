with checks as (
    select * from {{ ref('stg_quality_checks') }}
),

products as (
    select
        product_id,
        product_family,
        category
    from {{ ref('platform', 'dim_products') }}
)

select
    checks.store_id,
    checks.order_id,
    checks.checked_date_utc,
    products.product_family,
    products.category,
    cast(count(*) as integer) as quality_check_count,
    cast(sum(case when checks.check_result = 'pass' then 1 else 0 end) as integer) as passed_check_count,
    cast(sum(case when checks.check_result = 'review' then 1 else 0 end) as integer) as review_check_count,
    cast(sum(case when checks.check_result = 'fail' then 1 else 0 end) as integer) as failed_check_count,
    min(checks.checked_at_utc) as first_checked_at_utc,
    max(checks.checked_at_utc) as last_checked_at_utc
from checks
left join products on checks.product_id = products.product_id
group by 1, 2, 3, 4, 5
