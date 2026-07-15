{% docs jaffle_platform__int_order_items_enriched %}
Intermediate model for `int_order_items_enriched` transformation logic.
{% enddocs %}

{% docs platform__int_order_items_enriched__unit_cost_minor %}
Unit cost for the order item fact at one row per item, expressed in currency minor units.
{% enddocs %}

{% docs platform__int_order_items_enriched__supply_currency %}
Supply currency represented by the order item fact at one row per item. Aggregated from currency.
{% enddocs %}

{% docs platform__int_order_items_enriched__has_perishable_supply %}
Whether the order item fact at one row per item has perishable supply. Aggregated from perishable.
{% enddocs %}

{% docs platform__int_order_items_enriched__max_lead_time_days %}
Max lead time days for the order item fact at one row per item. Aggregated from lead time days.
{% enddocs %}

{% docs platform__int_order_items_enriched__estimated_supply_cost_minor %}
Estimated supply cost for the order item fact at one row per item, expressed in currency minor units. Derived from quantity and unit cost minor.
{% enddocs %}
