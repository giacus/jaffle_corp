{% docs store_ops__fct_order_service_times %}
Public operational interface for connecting an order to observed kitchen timing
and ready-target performance.

- **Grain:** one row per order and store represented in kitchen events.
- **Business rules:** rolls event timestamps into duration measures and compares
  received-to-ready minutes with the configurable kitchen-ready target, which
  defaults to 12 minutes.
- **Caveats:** missing lifecycle events can produce null durations and target
  status; orders without kitchen events are absent rather than synthesized.

A useful query compares target performance across stores:

```sql
select store_id, count(*) filter (where met_ready_target is not null) as observed_orders, avg(case when met_ready_target then 1.0 when not met_ready_target then 0.0 end) as ready_target_rate
from {% raw %}{{ ref('fct_order_service_times') }}{% endraw %}
group by 1
order by ready_target_rate
```
{% enddocs %}

{% docs store_ops__fct_order_service_times__order_service_time_key %}
Deterministic surrogate key for the order-level kitchen timing fact. Derived from order identifier and store identifier.
{% enddocs %}

{% docs store_ops__fct_order_service_times__received_to_ready_bucket %}
Received to ready bucket represented by the order-level kitchen timing fact. Derived from received to ready minutes.
{% enddocs %}

{% docs store_ops__fct_order_service_times__met_ready_target %}
Whether ready target was met for the order-level kitchen timing fact. Derived from received to ready minutes.
{% enddocs %}
