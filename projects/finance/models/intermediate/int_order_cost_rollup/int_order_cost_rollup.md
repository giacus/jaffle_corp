{% docs jaffle_finance__int_order_cost_rollup %}
Order-level cost rollup used to add item counts, quantities, and estimated supply
cost to recognized revenue.

- **Grain:** one row per `order_id` represented in item-cost inputs.
- **Business rules:** aggregates item records and quantities separately and sums
  sales and estimated cost at the order boundary.
- **Caveats:** orders with no item-cost rows do not appear here; the downstream
  revenue mart deliberately handles that absence when it performs its left join.

A useful query checks the distribution of estimated cost across orders:

```sql
select order_item_count, count(*) as orders, avg(estimated_supply_cost_usd) as avg_estimated_supply_cost_usd
from {% raw %}{{ ref('int_order_cost_rollup') }}{% endraw %}
group by 1
order by 1
```
{% enddocs %}

{% docs finance__int_order_cost_rollup__order_item_count %}
Number of order item records represented by each `int_order_cost_rollup` row.
{% enddocs %}

{% docs finance__int_order_cost_rollup__total_item_quantity %}
The total item quantity value produced for each `int_order_cost_rollup` row. Derived from quantity.
{% enddocs %}

{% docs finance__int_order_cost_rollup__item_sales_major %}
The item sales major value produced for each `int_order_cost_rollup` row. Derived from item total major.
{% enddocs %}

{% docs finance__int_order_cost_rollup__estimated_supply_cost_usd %}
The estimated supply cost usd value produced for each `int_order_cost_rollup` row.
{% enddocs %}
