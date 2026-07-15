{% docs jaffle_finance__int_order_item_costs %}
Intermediate model for `int_order_item_costs` transformation logic.
{% enddocs %}

{% docs finance__int_order_item_costs__order_currency %}
The order currency value produced for each `int_order_item_costs` row. Derived from currency.
{% enddocs %}

{% docs finance__int_order_item_costs__estimated_supply_cost_major %}
The estimated supply cost major value produced for each `int_order_item_costs` row. Derived from estimated supply cost minor.
{% enddocs %}

{% docs finance__int_order_item_costs__estimated_supply_cost_usd %}
The estimated supply cost usd value produced for each `int_order_item_costs` row. Derived from usd per order currency unit and estimated supply cost minor.
{% enddocs %}
