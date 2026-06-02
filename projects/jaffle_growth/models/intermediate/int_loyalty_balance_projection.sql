with loyalty_events as (
    select * from {{ ref('jaffle_platform', 'fct_loyalty_events') }}
),

daily_events as (
    select
        customer_id,
        event_date_utc,
        sum(points_delta) as points_delta,
        max(program_tier) as latest_program_tier,
        count(*) as loyalty_event_count
    from loyalty_events
    group by 1, 2
)

select
    customer_id,
    event_date_utc,
    points_delta,
    sum(points_delta) over (
        partition by customer_id
        order by event_date_utc
        rows between unbounded preceding and current row
    ) as projected_points_balance,
    latest_program_tier,
    loyalty_event_count,
    case
        when sum(points_delta) over (
            partition by customer_id
            order by event_date_utc
            rows between unbounded preceding and current row
        ) < 0 then 'negative_balance_review'
        when latest_program_tier = 'gold' then 'high_engagement'
        else 'standard'
    end as loyalty_balance_status
from daily_events
