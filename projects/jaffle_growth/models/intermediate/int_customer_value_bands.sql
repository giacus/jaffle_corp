with customers as (
    select * from {{ ref('jaffle_platform', 'dim_customers') }}
),

finance as (
    select
        customer_id,
        count(distinct order_id) as finance_order_count,
        sum(net_revenue_usd) as lifetime_net_revenue_usd,
        sum(recipe_margin_usd) as lifetime_recipe_margin_usd,
        max(recognized_date) as most_recent_recognized_date
    from {{ ref('jaffle_finance', 'fct_order_margin_waterfall') }}
    group by 1
),

support as (
    select
        customer_id,
        count(*) as support_ticket_count,
        sum(case when met_first_response_sla then 1 else 0 end) as first_response_sla_met_count,
        sum(concession_major) as concession_major
    from {{ ref('jaffle_experience', 'fct_support_tickets') }}
    group by 1
),

experiments as (
    select
        customer_id,
        count(*) as exposure_count,
        sum(case when converted_7d then 1 else 0 end) as converted_exposure_count
    from {{ ref('jaffle_experience', 'fct_experiment_outcomes') }}
    group by 1
)

select
    customers.customer_id,
    customers.customer_name,
    customers.loyalty_region,
    customers.lifecycle_stage,
    customers.marketing_consent,
    coalesce(finance.finance_order_count, 0) as finance_order_count,
    coalesce(finance.lifetime_net_revenue_usd, 0) as lifetime_net_revenue_usd,
    coalesce(finance.lifetime_recipe_margin_usd, 0) as lifetime_recipe_margin_usd,
    finance.most_recent_recognized_date,
    coalesce(support.support_ticket_count, 0) as support_ticket_count,
    coalesce(support.first_response_sla_met_count, 0) as first_response_sla_met_count,
    coalesce(support.concession_major, 0) as concession_major,
    coalesce(experiments.exposure_count, 0) as exposure_count,
    coalesce(experiments.converted_exposure_count, 0) as converted_exposure_count,
    case
        when coalesce(finance.lifetime_recipe_margin_usd, 0) >= 20 then 'high_margin'
        when coalesce(finance.lifetime_net_revenue_usd, 0) >= 20 then 'high_revenue_low_margin'
        when coalesce(finance.finance_order_count, 0) >= 2 then 'repeat'
        when customers.lifecycle_stage = 'prospect' then 'prospect'
        else 'emerging'
    end as value_band,
    case
        when coalesce(support.support_ticket_count, 0) >= 2 then 'support_sensitive'
        when coalesce(support.concession_major, 0) > 0 then 'concession_seen'
        else 'standard'
    end as care_profile
from customers
left join finance on customers.customer_id = finance.customer_id
left join support on customers.customer_id = support.customer_id
left join experiments on customers.customer_id = experiments.customer_id
