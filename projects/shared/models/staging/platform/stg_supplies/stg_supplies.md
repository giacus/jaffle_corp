{% docs platform__stg_supplies %}
Staging model for `stg_supplies` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_supplies__supply_id %}
Source-system identifier for the supply.
{% enddocs %}

{% docs shared__stg_supplies__supplier_name %}
Human-readable name of the supplier for the sellable-product supply.
{% enddocs %}

{% docs shared__stg_supplies__supplier_country_code %}
Normalized code identifying supplier country.
{% enddocs %}

{% docs shared__stg_supplies__unit_cost_minor %}
Unit cost of the sellable-product supply, expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_supplies__unit_cost_major %}
Unit cost of the sellable-product supply, expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_supplies__perishable %}
Whether the component is treated as perishable for supply planning.
{% enddocs %}

{% docs shared__stg_supplies__lead_time_days %}
Duration in days for lead time.
{% enddocs %}

{% docs shared__stg_supplies__replenishment_mode %}
Replenishment mode recorded on the supplies record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_supplies__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_supplies` record.
{% enddocs %}
