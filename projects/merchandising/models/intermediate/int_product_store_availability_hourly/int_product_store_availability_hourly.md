{% docs jaffle_merchandising__int_product_store_availability_hourly %}
Intermediate model for `int_product_store_availability_hourly` transformation logic.
{% enddocs %}

{% docs merchandising__int_product_store_availability_hourly__product_store_hour_key %}
Deterministic surrogate key for the availability fact at product-store-hour grain. Derived from product identifier, store identifier, hour local, and available date UTC.
{% enddocs %}

{% docs merchandising__int_product_store_availability_hourly__availability_hour_utc %}
UTC timestamp identifying the product-store availability observation hour. Derived from the store-local date and hour.
{% enddocs %}

{% docs merchandising__int_product_store_availability_hourly__availability_health %}
Availability health represented by the availability fact at product-store-hour grain. Derived from availability status, observed on hand units, and expected menu units.
{% enddocs %}

{% docs merchandising__int_product_store_availability_hourly__available_hour_count %}
Number of available hours represented by the availability fact at product-store-hour grain. Derived from availability status.
{% enddocs %}

{% docs merchandising__int_product_store_availability_hourly__constrained_hour_count %}
Number of constrained hours represented by the availability fact at product-store-hour grain. Derived from availability status.
{% enddocs %}

{% docs merchandising__int_product_store_availability_hourly__unavailable_hour_count %}
Number of unavailable hours represented by the availability fact at product-store-hour grain. Derived from availability status.
{% enddocs %}
