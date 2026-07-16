{% docs supply__int_component_daily_usage %}
Intermediate model for `int_component_daily_usage` transformation logic.
{% enddocs %}

{% docs supply__int_component_daily_usage__usage_date_utc %}
UTC calendar date for usage on each `int_component_daily_usage` row. Derived from ordered date utc.
{% enddocs %}

{% docs supply__int_component_daily_usage__expected_used_quantity %}
The expected used quantity value produced for each `int_component_daily_usage` row. Derived from quantity and quantity per item.
{% enddocs %}

{% docs supply__int_component_daily_usage__expected_recipe_waste_quantity %}
The expected recipe waste quantity value produced for each `int_component_daily_usage` row. Derived from waste factor, quantity, and quantity per item.
{% enddocs %}

{% docs supply__int_component_daily_usage__order_count_using_component %}
The order count using component value produced for each `int_component_daily_usage` row. Derived from order id.
{% enddocs %}

{% docs supply__int_component_daily_usage__item_quantity_using_component %}
The item quantity using component value produced for each `int_component_daily_usage` row. Derived from quantity.
{% enddocs %}
