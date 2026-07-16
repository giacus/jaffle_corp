{% docs platform__stg_products %}
Staging model for `stg_products` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_products__product_id %}
Source-system identifier for the sellable product.
{% enddocs %}

{% docs shared__stg_products__sku %}
Stock-keeping unit used to identify the product in operational systems.
{% enddocs %}

{% docs shared__stg_products__product_name %}
Human-readable name of the product.
{% enddocs %}

{% docs shared__stg_products__category %}
Business category assigned to the product.
{% enddocs %}

{% docs shared__stg_products__product_family %}
Business grouping used to organize products with similar menu roles.
{% enddocs %}

{% docs shared__stg_products__list_price_minor %}
List price expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_products__list_price_usd %}
List price expressed in US dollars.
{% enddocs %}

{% docs shared__stg_products__catalog_currency %}
ISO 4217 currency code used for the product catalog price.
{% enddocs %}

{% docs shared__stg_products__is_limited_time %}
Whether the source record is classified as limited time.
{% enddocs %}

{% docs shared__stg_products__introduced_at %}
Introduced at recorded on the products record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_products__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
