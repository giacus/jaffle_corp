{% docs platform__stg_customers %}
Staging model for `stg_customers` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_customers__customer_id %}
Source-system identifier for the customer.
{% enddocs %}

{% docs shared__stg_customers__customer_name %}
Human-readable name of the customer.
{% enddocs %}

{% docs shared__stg_customers__email %}
Email recorded on the customers record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_customers__email_domain %}
Domain portion of the customer email address, normalized for grouping.
{% enddocs %}

{% docs shared__stg_customers__loyalty_region %}
Regional loyalty-program grouping assigned to the customer.
{% enddocs %}

{% docs shared__stg_customers__first_seen_at %}
First seen at recorded on the customers record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_customers__default_currency %}
ISO 4217 currency code used as the customer default.
{% enddocs %}

{% docs shared__stg_customers__marketing_consent %}
Whether the customer granted marketing communication consent.
{% enddocs %}

{% docs shared__stg_customers__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_customers` record.
{% enddocs %}
