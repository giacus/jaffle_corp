{% docs jaffle_merchandising__stg_menu_publications %}
Staging model for `stg_menu_publications` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_menu_publications__publication_id %}
Source-system identifier for the publication.
{% enddocs %}

{% docs shared__stg_menu_publications__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_menu_publications__product_id %}
Source-system identifier for the sellable product.
{% enddocs %}

{% docs shared__stg_menu_publications__published_at_utc %}
UTC timestamp when published occurred.
{% enddocs %}

{% docs shared__stg_menu_publications__retired_at_utc %}
UTC timestamp when retired occurred.
{% enddocs %}

{% docs shared__stg_menu_publications__menu_section %}
Menu section in which the product publication appears.
{% enddocs %}

{% docs shared__stg_menu_publications__display_rank %}
Display rank recorded on the menu publications record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_menu_publications__is_featured %}
Whether the source record is classified as featured.
{% enddocs %}

{% docs shared__stg_menu_publications__published_price_minor %}
Published price expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_menu_publications__currency %}
ISO 4217 currency code attached to monetary values on the source record.
{% enddocs %}

{% docs shared__stg_menu_publications__menu_surface %}
Customer-facing menu surface on which the publication appears.
{% enddocs %}

{% docs shared__stg_menu_publications__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
