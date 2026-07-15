{% docs jaffle_merchandising__int_menu_product_windows %}
Intermediate model for `int_menu_product_windows` transformation logic.
{% enddocs %}

{% docs merchandising__int_menu_product_windows__menu_product_window_key %}
Deterministic surrogate key for the menu publication dimension at one row per store-product publication window. Derived from publication identifier, store identifier, and product identifier.
{% enddocs %}

{% docs merchandising__int_menu_product_windows__effective_to_utc %}
UTC timestamp for effective to on each `int_menu_product_windows` row. Derived from retired at utc.
{% enddocs %}

{% docs merchandising__int_menu_product_windows__menu_price_band %}
Derived business classification for menu price band on the menu publication dimension at one row per store-product publication window. Derived from published price minor.
{% enddocs %}
