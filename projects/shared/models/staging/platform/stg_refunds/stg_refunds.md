{% docs platform__stg_refunds %}
Staging model for `stg_refunds` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_refunds__refund_id %}
Source-system identifier for the refund.
{% enddocs %}

{% docs shared__stg_refunds__order_id %}
Source-system identifier for the order.
{% enddocs %}

{% docs shared__stg_refunds__refund_reason %}
Normalized business classification for refund reason.
{% enddocs %}

{% docs shared__stg_refunds__refunded_at_utc %}
UTC timestamp when refunded occurred.
{% enddocs %}

{% docs shared__stg_refunds__refunded_date_utc %}
UTC calendar date associated with refunded.
{% enddocs %}

{% docs shared__stg_refunds__refund_amount_minor %}
Refund amount expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_refunds__refund_amount_major %}
Refund amount expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_refunds__currency %}
ISO 4217 currency code attached to monetary values on the source record.
{% enddocs %}

{% docs shared__stg_refunds__initiated_by %}
Initiated by recorded on the refunds record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_refunds__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
