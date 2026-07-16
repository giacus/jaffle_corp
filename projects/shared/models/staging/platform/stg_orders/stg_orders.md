{% docs platform__stg_orders %}
Staging model for `stg_orders` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_orders__order_id %}
Source-system identifier for the order.
{% enddocs %}

{% docs shared__stg_orders__customer_id %}
Source-system identifier for the customer.
{% enddocs %}

{% docs shared__stg_orders__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_orders__ordered_at_utc %}
UTC timestamp when the order was placed.
{% enddocs %}

{% docs shared__stg_orders__ordered_date_utc %}
UTC calendar date on which the order was placed.
{% enddocs %}

{% docs shared__stg_orders__order_status %}
Normalized lifecycle status of the order. Allowed normalized values: `cancelled`, `completed`, `placed`, `refunded`, `unknown`.
{% enddocs %}

{% docs shared__stg_orders__raw_order_status %}
Unmodified order status retained for audit and migration work.
{% enddocs %}

{% docs shared__stg_orders__channel %}
Normalized acquisition or ordering channel recorded by the source.
{% enddocs %}

{% docs shared__stg_orders__currency %}
ISO 4217 currency code attached to monetary values on the source record.
{% enddocs %}

{% docs shared__stg_orders__subtotal_minor %}
Subtotal expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_orders__tax_minor %}
Tax expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_orders__discount_minor %}
Discount expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_orders__service_fee_minor %}
Service fee expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_orders__loyalty_points_redeemed %}
Number of loyalty points redeemed on the order.
{% enddocs %}

{% docs shared__stg_orders__order_total_minor %}
Order total expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_orders__order_total_major %}
Order total expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_orders__legacy_order_number %}
Legacy human-facing order number retained for compatibility exercises.
{% enddocs %}

{% docs shared__stg_orders__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
