{% docs jaffle_supply__int_inventory_daily_balance %}
Intermediate model for `int_inventory_daily_balance` transformation logic.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__store_id %}
Identifier of the store represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__component_id %}
Identifier of the component represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__balance_date_utc %}
Calendar date for balance on the component inventory fact at store-component-day grain. Derived from counted date UTC.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__unit %}
Unit represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__counted_quantity %}
Counted quantity represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__received_quantity %}
Received quantity represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__expected_used_quantity %}
Expected used quantity represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__expected_recipe_waste_quantity %}
Expected recipe waste quantity represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__observed_waste_quantity %}
Observed waste quantity represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__waste_event_count %}
Number of waste events represented by the component inventory fact at store-component-day grain.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__received_cost_usd %}
Received cost for the component inventory fact at store-component-day grain, expressed in US dollars.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__has_count_review %}
Whether the component inventory fact at store-component-day grain has count review.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__has_late_receipt %}
Whether the component inventory fact at store-component-day grain has late receipt.
{% enddocs %}

{% docs supply__int_inventory_daily_balance__estimated_closing_quantity %}
Estimated closing quantity represented by the component inventory fact at store-component-day grain. Derived from observed waste quantity, expected used quantity, counted quantity, and received quantity.
{% enddocs %}
