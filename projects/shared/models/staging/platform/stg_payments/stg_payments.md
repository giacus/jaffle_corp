{% docs jaffle_platform__stg_payments %}
Staging model for `stg_payments` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_payments__payment_id %}
Source-system identifier for the payment.
{% enddocs %}

{% docs shared__stg_payments__order_id %}
Source-system identifier for the order.
{% enddocs %}

{% docs shared__stg_payments__payment_status %}
Normalized business classification for payment status. Allowed normalized values: `authorized`, `captured`, `failed`, `refunded`, `unknown`.
{% enddocs %}

{% docs shared__stg_payments__raw_payment_status %}
Normalized business classification for raw payment status.
{% enddocs %}

{% docs shared__stg_payments__payment_method %}
Normalized payment method used for the payment attempt.
{% enddocs %}

{% docs shared__stg_payments__authorized_at_utc %}
UTC timestamp when authorized occurred.
{% enddocs %}

{% docs shared__stg_payments__captured_at_utc %}
UTC timestamp when captured occurred.
{% enddocs %}

{% docs shared__stg_payments__amount_minor %}
Amount expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_payments__amount_major %}
Amount expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_payments__currency %}
ISO 4217 currency code attached to monetary values on the source record.
{% enddocs %}

{% docs shared__stg_payments__processor_region %}
Processor region recorded on the payments record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_payments__updated_at_utc %}
UTC timestamp when the source system last updated the record.
{% enddocs %}
