select
    order_id as order_no,
    product_id as prod,
    product_family,
    category as cat,
    quantity as qty,
    item_total_major as item_amt,
    estimated_supply_cost_minor as supply_minor_guess,
    ordered_date_utc as business_dt
from {{ ref('jaffle_platform', 'fct_order_items') }}
