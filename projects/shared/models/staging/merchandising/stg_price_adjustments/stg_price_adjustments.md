{% docs merchandising__stg_price_adjustments %}
Typed source boundary for temporary product-store price adjustments.

- **Grain:** one source row per `price_adjustment_id`.
- **Business rules:** casts identifiers, timestamps, classifications, and minor
  currency units without resolving publication windows or applying pricing
  policy.
- **Caveats:** a null end timestamp means open-ended, and this staging boundary
  does not prevent invalid ranges or overlapping adjustments.

A useful source-profile query checks the reason mix and open-ended records:

```sql
select adjustment_reason, count(*) as adjustments, count(*) filter (where effective_to_utc is null) as open_ended
from {% raw %}{{ ref('stg_price_adjustments') }}{% endraw %}
group by 1
order by 1
```
{% enddocs %}

{% docs shared__stg_price_adjustments__price_adjustment_id %}
Source-system identifier for the price adjustment.
{% enddocs %}

{% docs shared__stg_price_adjustments__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_price_adjustments__product_id %}
Source-system identifier for the sellable product.
{% enddocs %}

{% docs shared__stg_price_adjustments__effective_from_utc %}
UTC timestamp at which the record becomes effective.
{% enddocs %}

{% docs shared__stg_price_adjustments__effective_to_utc %}
UTC timestamp at which the record stops being effective; null means open-ended.
{% enddocs %}

{% docs shared__stg_price_adjustments__adjustment_reason %}
Normalized business classification for adjustment reason. Allowed normalized values: `case_test`, `morning_bundle`, `seasonal_test`, `side_hour`, `stock_balance`.
{% enddocs %}

{% docs shared__stg_price_adjustments__adjustment_price_minor %}
Adjustment price expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_price_adjustments__approved_by_role %}
Normalized business classification for approved by role. Allowed normalized values: `analyst`, `menu_lead`, `store_lead`.
{% enddocs %}

{% docs shared__stg_price_adjustments__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
