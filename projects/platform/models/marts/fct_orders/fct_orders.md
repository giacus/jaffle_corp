{% docs platform__fct_orders %}
Primary public interface for order-level analysis and downstream domain packages.

- **Grain:** one row per `order_id`.
- **Business rules:** enriches the source order with store context, payment and
  refund rollups, USD conversion, and completed/cancelled flags before exposing
  a contracted relation.
- **Caveats:** captured and refunded amounts can differ from the stated order
  total, non-completed orders remain present, and USD values use the fixture's
  synthetic exchange-rate logic rather than an accounting ledger.

A useful first query checks order volume and value by status without collapsing
the model's order grain:

```sql
select ordered_date_utc, order_status, count(*) as orders, sum(order_total_usd) as order_value_usd
from {% raw %}{{ ref('fct_orders') }}{% endraw %}
group by 1, 2
order by 1, 2
```
{% enddocs %}

{% docs platform__fct_orders__order_key %}
Deterministic surrogate key for the order fact at one row per order. Derived from order identifier and ordered at UTC.
{% enddocs %}
