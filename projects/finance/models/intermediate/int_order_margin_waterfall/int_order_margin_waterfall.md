{% docs jaffle_finance__int_order_margin_waterfall %}
Intermediate model for `int_order_margin_waterfall` transformation logic.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__platform_supply_cost_usd %}
Platform supply cost for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated supply cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__recipe_expected_component_cost_usd %}
Recipe expected component cost for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__recipe_cost_variance_usd %}
Recipe cost variance for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated supply cost USD and recipe expected component cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__recipe_margin_usd %}
Recipe margin for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from net revenue USD and recipe expected component cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__platform_margin_usd %}
Platform margin for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated gross margin USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__margin_method_variance_usd %}
Margin method variance for the finance fact comparing platform-estimated and recipe-derived margin, expressed in US dollars. Derived from estimated gross margin USD, net revenue USD, and recipe expected component cost USD.
{% enddocs %}

{% docs finance__int_order_margin_waterfall__component_count %}
Number of components represented by the finance fact comparing platform-estimated and recipe-derived margin.
{% enddocs %}
