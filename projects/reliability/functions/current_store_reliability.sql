coalesce(
    (
        select {{ function('reliability_status') }}(reliability_score)
        from {{ ref('fct_store_day_reliability') }} as reliability_history
        where
            reliability_history.store_id = lookup_store_id
            and reliability_history.reliability_date <= lookup_date
        order by reliability_history.reliability_date desc
        limit 1
    ),
    'unobserved'
)
