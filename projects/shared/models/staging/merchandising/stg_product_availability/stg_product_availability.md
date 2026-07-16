{% docs merchandising__stg_product_availability %}
Staging model for `stg_product_availability` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_product_availability__availability_id %}
Source-system identifier for the availability.
{% enddocs %}

{% docs shared__stg_product_availability__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_product_availability__product_id %}
Source-system identifier for the sellable product.
{% enddocs %}

{% docs shared__stg_product_availability__available_date_utc %}
UTC calendar date associated with available.
{% enddocs %}

{% docs shared__stg_product_availability__hour_local %}
Store-local hour represented by the forecast record.
{% enddocs %}

{% docs shared__stg_product_availability__availability_status %}
Normalized availability state observed for the product at the store. Allowed normalized values: `available`, `limited`, `unavailable`, `unknown`.
{% enddocs %}

{% docs shared__stg_product_availability__observed_on_hand_units %}
Component units observed on hand during the inventory count.
{% enddocs %}

{% docs shared__stg_product_availability__expected_menu_units %}
Expected number of menu units under the capacity scenario.
{% enddocs %}

{% docs shared__stg_product_availability__outage_minutes %}
Duration in minutes for outage.
{% enddocs %}

{% docs shared__stg_product_availability__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
