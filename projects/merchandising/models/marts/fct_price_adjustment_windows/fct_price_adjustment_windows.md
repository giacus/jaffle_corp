{% docs jaffle_merchandising__fct_price_adjustment_windows %}
Public interface for evaluating a temporary product-store price against the menu
publication active when the adjustment begins.

- **Grain:** one row per price adjustment, store, and product combination.
- **Business rules:** matches on the adjustment start timestamp, compares the
  adjusted and published prices, and classifies the adjusted price into a band.
- **Caveats:** it does not enforce non-overlapping adjustment windows; an
  unmatched menu publication leaves comparison fields null, and later menu
  changes inside an adjustment window are not split into additional rows.

A useful query summarizes the direction and size of adjustments by reason:

```sql
select adjustment_reason, count(*) as adjustments, avg(adjustment_delta_rate) as avg_adjustment_delta_rate
from {% raw %}{{ ref('fct_price_adjustment_windows') }}{% endraw %}
group by 1
order by 1
```
{% enddocs %}
