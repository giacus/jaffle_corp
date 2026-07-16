{% docs legacy__legacy_order_margin_v0 %}
Deprecated order margin model with intentionally approximate supply costs.
{% enddocs %}

{% docs legacy__legacy_order_margin_v0__approximate_supply_cost_major %}
The approximate supply cost major value produced for each `legacy_order_margin_v0` row.
{% enddocs %}

{% docs legacy__legacy_order_margin_v0__margin_guess_major %}
The margin guess major value produced for each `legacy_order_margin_v0` row. Derived from net amt and approximate supply cost major.
{% enddocs %}

{% docs legacy__legacy_order_margin_v0__needs_currency_review %}
Boolean indicator for needs currency review on the row produced by `legacy_order_margin_v0`. Derived from money kind.
{% enddocs %}
