{% docs store_ops__stg_quality_checks %}
Staging model for `stg_quality_checks` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_quality_checks__quality_check_id %}
Source-system identifier for the quality check.
{% enddocs %}

{% docs shared__stg_quality_checks__check_type %}
Normalized business classification for check type.
{% enddocs %}

{% docs shared__stg_quality_checks__check_result %}
Normalized pass, review, or fail result of the quality check. Allowed normalized values: `fail`, `pass`, `review`.
{% enddocs %}

{% docs shared__stg_quality_checks__measured_value %}
Measured value recorded on the quality checks record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_quality_checks__expected_min %}
Lower bound of the forecast prediction interval.
{% enddocs %}

{% docs shared__stg_quality_checks__expected_max %}
Upper bound of the forecast prediction interval.
{% enddocs %}

{% docs shared__stg_quality_checks__checked_at_utc %}
UTC timestamp when checked occurred.
{% enddocs %}

{% docs shared__stg_quality_checks__checked_date_utc %}
UTC calendar date associated with checked.
{% enddocs %}

{% docs shared__stg_quality_checks__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_quality_checks` record.
{% enddocs %}
