{% docs supply__stg_purchase_orders %}
Staging model for `stg_purchase_orders` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_purchase_orders__purchase_order_id %}
Source-system identifier for the purchase order.
{% enddocs %}

{% docs shared__stg_purchase_orders__supplier_name %}
Human-readable name of the supplier fulfilling the component purchase order.
{% enddocs %}

{% docs shared__stg_purchase_orders__ordered_at_utc %}
UTC timestamp when the component purchase order was placed.
{% enddocs %}

{% docs shared__stg_purchase_orders__expected_at_utc %}
UTC timestamp when expected occurred.
{% enddocs %}

{% docs shared__stg_purchase_orders__received_at_utc %}
UTC timestamp when received occurred.
{% enddocs %}

{% docs shared__stg_purchase_orders__purchase_order_status %}
Normalized business classification for purchase order status. Allowed normalized values: `cancelled`, `open`, `partially_received`, `received`, `unknown`.
{% enddocs %}

{% docs shared__stg_purchase_orders__raw_purchase_order_status %}
Normalized business classification for raw purchase order status.
{% enddocs %}

{% docs shared__stg_purchase_orders__quantity_ordered %}
Component quantity requested on the purchase order.
{% enddocs %}

{% docs shared__stg_purchase_orders__quantity_received %}
Component quantity received against the purchase order.
{% enddocs %}

{% docs shared__stg_purchase_orders__unit_cost_minor %}
Unit cost of the purchased component, expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_purchase_orders__unit_cost_major %}
Unit cost of the purchased component, expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_purchase_orders__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_purchase_orders` record.
{% enddocs %}
