with order_totals as (
    select
        order_id,
        subtotal_minor,
        tax_minor
    from {{ ref('fct_orders') }}
),

item_totals as (
    select
        order_id,
        sum(item_subtotal_minor) as item_subtotal_minor,
        sum(item_tax_minor) as item_tax_minor
    from {{ ref('fct_order_items') }}
    group by 1
)

select
    order_totals.order_id,
    order_totals.subtotal_minor,
    item_totals.item_subtotal_minor,
    order_totals.tax_minor,
    item_totals.item_tax_minor
from order_totals
left join item_totals on order_totals.order_id = item_totals.order_id
where
    order_totals.subtotal_minor <> coalesce(item_totals.item_subtotal_minor, 0)
    or abs(order_totals.tax_minor - coalesce(item_totals.item_tax_minor, 0)) > 1
