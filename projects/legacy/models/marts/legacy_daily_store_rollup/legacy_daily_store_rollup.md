{% docs jaffle_legacy__legacy_daily_store_rollup %}
Deprecated mixed-currency store-day rollup retained for migration exercises.
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
