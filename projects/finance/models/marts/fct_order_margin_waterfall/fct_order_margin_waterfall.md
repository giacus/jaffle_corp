{% docs finance__fct_order_margin_waterfall %}
Public Finance interface for comparing platform-estimated and recipe-derived
order margin without joining the underlying item and component tables.

- **Grain:** one row per `order_id`; the surrogate key combines `order_id` and
  `recognized_date`, which follows the fixture's order date.
- **Business meaning:** net revenue is shared by both margin methods. Their
  difference isolates the effect of the cost estimate, not a change in sales
  or refunds. Positive `margin_method_variance_usd` means the platform method
  reports more margin than the recipe method.
- **Caveats:** costs and FX are synthetic estimates, not an accounting ledger.
  Missing recipe coverage is treated as zero cost upstream. Check the component
  bridge before interpreting unusually high recipe margins; a zero aggregate
  component count is a useful warning, not a complete coverage test.

Compare daily margin estimates while keeping revenue-quality categories visible:

```sql
select recognized_date, revenue_quality_status,
       sum(platform_margin_usd) as platform_margin_usd,
       sum(recipe_margin_usd) as recipe_margin_usd,
       sum(margin_method_variance_usd) as margin_difference_usd
from {% raw %}{{ ref('fct_order_margin_waterfall') }}{% endraw %}
group by 1, 2
order by 1, 2
```
{% enddocs %}

{% docs finance__fct_order_margin_waterfall__order_margin_waterfall_key %}
Deterministic surrogate key for the finance fact comparing platform-estimated and recipe-derived margin. Derived from order identifier and recognized date.
{% enddocs %}
