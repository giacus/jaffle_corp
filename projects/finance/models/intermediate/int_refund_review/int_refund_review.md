{% docs finance__int_refund_review %}
Refunded orders for an optional finance review. Set `include_refund_review` to
the boolean `true` to include this model; routine builds leave it disabled.
The model keeps the order's converted refund amount and event count so the
review starts from the same payment allocations as the finance marts.
{% enddocs %}
