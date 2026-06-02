with headers as (
    select * from {{ ref('stg_legacy_order_headers') }}
),

items as (
    select
        order_id,
        sum(item_total_major) as item_total_major,
        sum({{ jaffle_shared.minor_units_to_major_units('estimated_supply_cost_minor') }})
            as approximate_supply_cost_major
    from {{ ref('jaffle_platform', 'fct_order_items') }}
    group by 1
)

select
    headers.order_no,
    headers.modern_order_id,
    headers.cust,
    headers.shop,
    headers.business_dt,
    headers.old_status_bucket,
    headers.money_kind,
    headers.gross_amt,
    headers.net_amt,
    coalesce(items.approximate_supply_cost_major, 0) as approximate_supply_cost_major,
    headers.net_amt - coalesce(items.approximate_supply_cost_major, 0) as margin_guess_major,
    case
        when headers.money_kind != '{{ var("legacy_default_currency") }}' then true
        else false
    end as needs_currency_review
from headers
left join items on headers.modern_order_id = items.order_id
