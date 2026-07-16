{% docs merchandising__int_menu_item_margin_baseline %}
Intermediate model for `int_menu_item_margin_baseline` transformation logic.
{% enddocs %}

{% docs merchandising__int_menu_item_margin_baseline__menu_item_margin_baseline_key %}
Deterministic surrogate key for the recipe-cost margin baseline at store-product publication-window grain. Derived from menu product window key.
{% enddocs %}

{% docs merchandising__int_menu_item_margin_baseline__published_price_major %}
Published price for the recipe-cost margin baseline at store-product publication-window grain, expressed in currency major units. Derived from published price minor.
{% enddocs %}

{% docs merchandising__int_menu_item_margin_baseline__published_price_usd %}
Published price for the recipe-cost margin baseline at store-product publication-window grain, expressed in US dollars. Derived from USD rate and published price minor.
{% enddocs %}

{% docs merchandising__int_menu_item_margin_baseline__expected_recipe_cost_usd %}
Expected recipe cost for the recipe-cost margin baseline at store-product publication-window grain, expressed in US dollars.
{% enddocs %}

{% docs merchandising__int_menu_item_margin_baseline__expected_recipe_margin_usd %}
Expected recipe margin for the recipe-cost margin baseline at store-product publication-window grain, expressed in US dollars. Derived from USD rate, expected recipe cost USD, and published price minor.
{% enddocs %}

{% docs merchandising__int_menu_item_margin_baseline__expected_recipe_margin_rate %}
Expected recipe margin rate for the recipe-cost margin baseline at store-product publication-window grain, expressed as a decimal ratio. Derived from USD rate, expected recipe cost USD, and published price minor.
{% enddocs %}

{% docs merchandising__int_menu_item_margin_baseline__needs_cost_review %}
Whether the recipe-cost margin baseline at store-product publication-window grain requires cost review. Derived from is featured and expected recipe cost USD.
{% enddocs %}
