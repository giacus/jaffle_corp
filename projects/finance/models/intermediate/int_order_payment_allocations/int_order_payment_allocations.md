{% docs finance__int_order_payment_allocations %}
Finance policy layer that converts public platform payment activity into a
recognition-ready order record.

- **Grain:** one row per `order_id`.
- **Business rules:** infers an order-level USD conversion ratio, translates
  captured and refunded amounts, and assigns one revenue-quality status with a
  deliberate precedence from payment risk through pending.
- **Caveats:** a zero order total produces a zero conversion ratio, and the
  inferred ratio is a fixture simplification rather than transaction-level FX.

A useful review query makes the status precedence and monetary exposure visible:

```sql
select revenue_quality_status, count(*) as orders, sum(captured_amount_usd) as captured_usd, sum(refunded_amount_usd) as refunded_usd
from {% raw %}{{ ref('int_order_payment_allocations') }}{% endraw %}
group by 1
order by 1
```
{% enddocs %}

{% docs finance__int_order_payment_allocations__order_total_usd %}
The order total usd value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__captured_amount_major %}
The captured amount major value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__captured_amount_usd %}
Successfully captured payment amount expressed in US dollars. Derived from captured amount major and USD per order currency unit.
{% enddocs %}

{% docs finance__int_order_payment_allocations__refunded_amount_major %}
The refunded amount major value produced for each `int_order_payment_allocations` row.
{% enddocs %}

{% docs finance__int_order_payment_allocations__refunded_amount_usd %}
Refunded payment amount expressed in US dollars. Derived from refunded amount major and USD per order currency unit.
{% enddocs %}

{% docs finance__int_order_payment_allocations__payment_attempt_count %}
Number of payment attempts represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__refund_event_count %}
Number of refund events represented by the finance fact at one row per order.
{% enddocs %}

{% docs finance__int_order_payment_allocations__has_failed_payment %}
Whether the row produced by `int_order_payment_allocations` has failed payment.
{% enddocs %}

{% docs finance__int_order_payment_allocations__is_completed_order %}
Whether completed order is true for the row produced by `int_order_payment_allocations`.
{% enddocs %}

{% docs finance__int_order_payment_allocations__is_cancelled_order %}
Whether cancelled order is true for the row produced by `int_order_payment_allocations`.
{% enddocs %}

{% docs finance__int_order_payment_allocations__revenue_quality_status %}
Derived business classification for revenue quality status on the finance fact at one row per order. Derived from has failed payment, is cancelled order, is completed order, and refund event count.
{% enddocs %}
