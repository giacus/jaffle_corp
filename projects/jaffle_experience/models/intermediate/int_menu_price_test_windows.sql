with price_tests as (
    select * from {{ ref('stg_menu_price_tests') }}
),

products as (
    select
        product_id,
        product_name,
        category,
        product_family
    from {{ ref('jaffle_platform', 'dim_products') }}
),

order_items as (
    select
        order_items.order_item_id,
        order_items.order_id,
        orders.store_id,
        order_items.product_id,
        orders.ordered_at_utc,
        order_items.quantity,
        order_items.item_total_major
    from {{ ref('jaffle_platform', 'fct_order_items') }} as order_items
    inner join {{ ref('jaffle_platform', 'fct_orders') }} as orders
        on order_items.order_id = orders.order_id
)

select
    price_tests.price_test_id,
    price_tests.product_id,
    products.product_name,
    products.category,
    products.product_family,
    price_tests.store_id,
    price_tests.experiment_id,
    price_tests.variant_id,
    price_tests.effective_from_utc,
    price_tests.effective_to_utc,
    price_tests.list_price_minor,
    price_tests.list_price_major,
    price_tests.currency,
    cast(count(distinct order_items.order_id) as integer) as observed_order_count,
    cast(sum(coalesce(order_items.quantity, 0)) as integer) as observed_item_quantity,
    sum(coalesce(order_items.item_total_major, 0)) as observed_item_total_major,
    price_tests.updated_at_utc
from price_tests
left join products on price_tests.product_id = products.product_id
left join order_items
    on price_tests.product_id = order_items.product_id
    and price_tests.store_id = order_items.store_id
    and order_items.ordered_at_utc >= price_tests.effective_from_utc
    and order_items.ordered_at_utc < price_tests.effective_to_utc
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 17

