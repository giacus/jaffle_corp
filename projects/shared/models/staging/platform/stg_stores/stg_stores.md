{% docs platform__stg_stores %}
Staging model for `stg_stores` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_stores__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_stores__store_name %}
Human-readable name of the store.
{% enddocs %}

{% docs shared__stg_stores__country_code %}
ISO 3166-1 alpha-2 country code for the store location.
{% enddocs %}

{% docs shared__stg_stores__city %}
City recorded on the stores record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_stores__opened_at %}
Opened at recorded on the stores record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_stores__timezone_name %}
IANA timezone name used for the store location.
{% enddocs %}

{% docs shared__stg_stores__operating_currency %}
ISO 4217 currency code used by the store for operations. Allowed normalized values: `CAD`, `EUR`, `GBP`, `SGD`, `USD`.
{% enddocs %}

{% docs shared__stg_stores__tax_jurisdiction %}
Tax jurisdiction assigned to the store location.
{% enddocs %}

{% docs shared__stg_stores__franchise_owner %}
Fictional franchise owner associated with the store.
{% enddocs %}

{% docs shared__stg_stores__is_dark_kitchen %}
Whether the source record is classified as dark kitchen.
{% enddocs %}

{% docs shared__stg_stores__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
