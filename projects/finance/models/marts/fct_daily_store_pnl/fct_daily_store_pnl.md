{% docs finance__fct_daily_store_pnl %}
Public finance fact at one row per store per recognized date.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__store_pnl_key %}
Deterministic surrogate key for the finance fact at one row per store per recognized date. Derived from store identifier and recognized date.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__order_count %}
Number of orders represented by the finance fact at one row per store per recognized date.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__gross_revenue_usd %}
Order value before refunds, expressed in US dollars.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__net_revenue_usd %}
Captured revenue minus refunded revenue, expressed in US dollars.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__refunded_amount_usd %}
Refunded payment amount expressed in US dollars.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__estimated_supply_cost_usd %}
Estimated supply cost for the finance fact at one row per store per recognized date, expressed in US dollars.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__estimated_gross_margin_usd %}
Net revenue minus estimated supply cost, expressed in US dollars.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__order_item_count %}
Number of order items represented by the finance fact at one row per store per recognized date.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__total_item_quantity %}
Total item quantity represented by the finance fact at one row per store per recognized date.
{% enddocs %}

{% docs finance__fct_daily_store_pnl__payment_risk_order_count %}
Number of payment risk orders represented by the finance fact at one row per store per recognized date. Aggregated from revenue quality status.
{% enddocs %}
