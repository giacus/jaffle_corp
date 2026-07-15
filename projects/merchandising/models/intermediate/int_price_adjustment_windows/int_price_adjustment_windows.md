{% docs jaffle_merchandising__int_price_adjustment_windows %}
Intermediate model for `int_price_adjustment_windows` transformation logic.
{% enddocs %}

{% docs merchandising__int_price_adjustment_windows__price_adjustment_window_key %}
Deterministic surrogate key for the temporary price adjustment fact at product-store-window grain. Derived from price adjustment identifier, store identifier, and product identifier.
{% enddocs %}

{% docs merchandising__int_price_adjustment_windows__adjustment_delta_minor %}
Adjustment delta for the temporary price adjustment fact at product-store-window grain, expressed in currency minor units. Derived from adjustment price minor and published price minor.
{% enddocs %}

{% docs merchandising__int_price_adjustment_windows__adjustment_delta_rate %}
Adjustment delta rate for the temporary price adjustment fact at product-store-window grain, expressed as a decimal ratio. Derived from published price minor and adjustment price minor.
{% enddocs %}

{% docs merchandising__int_price_adjustment_windows__adjustment_price_band %}
Derived business classification for adjustment price band on the temporary price adjustment fact at product-store-window grain. Derived from adjustment price minor.
{% enddocs %}
