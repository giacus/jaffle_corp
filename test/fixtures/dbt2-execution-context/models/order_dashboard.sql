{{ config(tags=[target.name]) }}

-- Development previews use incoming orders; other targets use settled orders.
select * from {{ ref('orders' if target.name == 'dev' else 'settled_orders') }}

