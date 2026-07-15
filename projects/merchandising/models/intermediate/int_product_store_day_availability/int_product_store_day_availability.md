{% docs jaffle_merchandising__int_product_store_day_availability %}
Intermediate model for `int_product_store_day_availability` transformation logic.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__product_store_day_availability_key %}
Deterministic surrogate key for the availability fact at product-store-day grain. Derived from product identifier, store identifier, and available date UTC.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__product_family %}
Product family represented by the availability fact at product-store-day grain.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__menu_section %}
Menu section represented by the availability fact at product-store-day grain.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__menu_surface %}
Menu surface represented by the availability fact at product-store-day grain.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__country_code %}
Country code represented by the availability fact at product-store-day grain.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__city %}
City represented by the availability fact at product-store-day grain.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__observed_hour_count %}
Number of observed hour records represented by each `int_product_store_day_availability` row.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__available_hour_count %}
Number of available hour records represented by each `int_product_store_day_availability` row.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__constrained_hour_count %}
Number of constrained hour records represented by each `int_product_store_day_availability` row.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__unavailable_hour_count %}
Number of unavailable hour records represented by each `int_product_store_day_availability` row.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__outage_minutes %}
Outage minutes for the substitution-rule readiness fact at rule-day grain.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__average_observed_on_hand_units %}
Average observed on hand units represented by the availability fact at product-store-day grain. Aggregated from observed on hand units.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__average_expected_menu_units %}
Average expected menu units represented by the availability fact at product-store-day grain. Aggregated from expected menu units.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__availability_rate %}
Share of observed product-store hours classified as available, expressed from zero to one. Aggregated from available hour count.
{% enddocs %}

{% docs merchandising__int_product_store_day_availability__product_store_day_status %}
Derived business classification for product store day status on the substitution-rule readiness fact at rule-day grain. Aggregated from unavailable hour count and constrained hour count.
{% enddocs %}
