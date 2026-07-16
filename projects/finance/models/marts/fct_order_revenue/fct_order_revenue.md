{% docs finance__fct_order_revenue %}
Public Finance interface for recognized order revenue, refunds, estimated cost,
and gross-margin analysis.

- **Grain:** one row per `order_id`.
- **Business rules:** defines net revenue as captured less refunded USD, then
  subtracts estimated supply cost for an estimated gross margin. Missing item
  cost rollups are treated as zero.
- **Caveats:** `recognized_date` follows the order date in this fixture, the
  model is not a GAAP revenue ledger, and cost and FX values are estimates meant
  for analytical exercises.

A useful query reconciles recognized value and estimated margin by quality
status:

```sql
select revenue_quality_status, count(*) as orders, sum(net_revenue_usd) as net_revenue_usd, sum(estimated_gross_margin_usd) as estimated_gross_margin_usd
from {% raw %}{{ ref('fct_order_revenue') }}{% endraw %}
group by 1
order by 1
```
{% enddocs %}

{% docs finance__fct_order_revenue__order_revenue_key %}
Deterministic surrogate key for the finance fact at one row per order. Derived from order identifier and ordered date UTC.
{% enddocs %}

{% docs finance__fct_order_revenue__recognized_date %}
Calendar date for recognized on the finance fact at one row per order. Derived from ordered date UTC.
{% enddocs %}

{% docs finance__fct_order_revenue__gross_revenue_usd %}
Order value before refunds, expressed in US dollars. Derived from order total USD.
{% enddocs %}

{% docs finance__fct_order_revenue__net_revenue_usd %}
Captured revenue minus refunded revenue, expressed in US dollars. Derived from captured amount USD and refunded amount USD.
{% enddocs %}

{% docs finance__fct_order_revenue__tax_amount_major %}
Tax amount for the finance fact at one row per order, expressed in currency major units. Derived from tax minor.
{% enddocs %}

{% docs finance__fct_order_revenue__discount_amount_major %}
Discount amount for the finance fact at one row per order, expressed in currency major units. Derived from discount minor.
{% enddocs %}

{% docs finance__fct_order_revenue__service_fee_major %}
Service fee for the finance fact at one row per order, expressed in currency major units. Derived from service fee minor.
{% enddocs %}

{% docs finance__fct_order_revenue__estimated_supply_cost_usd %}
Estimated supply cost for the finance fact at one row per order, expressed in US dollars.
{% enddocs %}

{% docs finance__fct_order_revenue__estimated_gross_margin_usd %}
Net revenue minus estimated supply cost, expressed in US dollars. Derived from captured amount USD, refunded amount USD, and estimated supply cost USD.
{% enddocs %}

{% docs finance__fct_order_revenue__order_item_count %}
Number of order items represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__fct_order_revenue__total_item_quantity %}
Total item quantity represented by the finance fact at one row per order.
{% enddocs %}
