{% docs legacy__legacy_daily_store_rollup %}
Deprecated reporting interface retained to make migration and compatibility
trade-offs concrete.

- **Grain:** one row per legacy shop, business date, and money kind.
- **Business rules:** aggregates raw legacy monetary values and string-based
  status flags without modernizing their semantics.
- **Caveats:** amounts in different currencies are not comparable, legacy status
  buckets are intentionally opaque, and the surrogate key omits `money_kind`,
  relying on the fixture's one-currency-per-shop-day assumption.

A useful characterization query exposes any day that violates that currency
assumption before a refactor:

```sql
select shop, business_dt, count(distinct money_kind) as money_kinds
from {% raw %}{{ ref('legacy_daily_store_rollup') }}{% endraw %}
group by 1, 2
having count(distinct money_kind) > 1
```
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__legacy_store_day_key %}
Stable key identifying a row produced by `legacy_daily_store_rollup`. Derived from shop and business dt.
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__orders_cnt %}
The orders cnt value produced for each `legacy_daily_store_rollup` row.
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__gross_amt %}
The gross amt value produced for each `legacy_daily_store_rollup` row.
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__refund_amt %}
The refund amt value produced for each `legacy_daily_store_rollup` row.
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__net_amt %}
The net amt value produced for each `legacy_daily_store_rollup` row.
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__good_orders_cnt %}
The good orders cnt value produced for each `legacy_daily_store_rollup` row. Derived from old status bucket.
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__bad_orders_cnt %}
The bad orders cnt value produced for each `legacy_daily_store_rollup` row. Derived from old status bucket.
{% enddocs %}

{% docs legacy__legacy_daily_store_rollup__refund_orders_cnt %}
The refund orders cnt value produced for each `legacy_daily_store_rollup` row. Derived from has refund flag.
{% enddocs %}
