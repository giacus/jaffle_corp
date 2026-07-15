{% docs jaffle_platform__stg_order_items %}
Staging model for `stg_order_items` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_order_items__order_item_id %}
Source-system identifier for the order line item.
{% enddocs %}

{% docs shared__stg_order_items__order_id %}
Source-system identifier for the order.
{% enddocs %}

{% docs shared__stg_order_items__product_id %}
Source-system identifier for the sellable product.
{% enddocs %}

{% docs shared__stg_order_items__quantity %}
Number of product units recorded on the source line item.
{% enddocs %}

{% docs shared__stg_order_items__item_subtotal_minor %}
Item subtotal expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_order_items__item_discount_minor %}
Item discount expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_order_items__item_tax_minor %}
Item tax expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_order_items__item_total_minor %}
Item total expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_order_items__item_total_major %}
Item total expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_order_items__customization_count %}
Count of customization recorded by the source.
{% enddocs %}

{% docs shared__stg_order_items__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
