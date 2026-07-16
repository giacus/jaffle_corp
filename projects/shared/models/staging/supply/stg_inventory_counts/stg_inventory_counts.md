{% docs supply__stg_inventory_counts %}
Staging model for `stg_inventory_counts` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_inventory_counts__inventory_count_id %}
Source-system identifier for the inventory count.
{% enddocs %}

{% docs shared__stg_inventory_counts__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_inventory_counts__component_id %}
Source-system identifier for the component.
{% enddocs %}

{% docs shared__stg_inventory_counts__counted_at_utc %}
UTC timestamp when counted occurred.
{% enddocs %}

{% docs shared__stg_inventory_counts__counted_date_utc %}
UTC calendar date associated with counted.
{% enddocs %}

{% docs shared__stg_inventory_counts__quantity_on_hand %}
Component quantity recorded as currently on hand.
{% enddocs %}

{% docs shared__stg_inventory_counts__unit %}
Unit of measure used for the component quantity.
{% enddocs %}

{% docs shared__stg_inventory_counts__count_quality %}
Quality classification assigned to the inventory count. Allowed normalized values: `ok`, `review`.
{% enddocs %}

{% docs shared__stg_inventory_counts__source_version %}
Source version recorded on the inventory counts record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_inventory_counts__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
