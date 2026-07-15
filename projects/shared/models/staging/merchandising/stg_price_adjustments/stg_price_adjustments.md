{% docs jaffle_merchandising__stg_price_adjustments %}
Staging model for `stg_price_adjustments` source cleanup and normalization.
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
