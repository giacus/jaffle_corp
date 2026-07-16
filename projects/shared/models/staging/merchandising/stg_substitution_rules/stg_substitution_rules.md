{% docs merchandising__stg_substitution_rules %}
Staging model for `stg_substitution_rules` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_substitution_rules__substitution_rule_id %}
Source-system identifier for the substitution rule.
{% enddocs %}

{% docs shared__stg_substitution_rules__store_id %}
Source-system identifier for the store or operating location.
{% enddocs %}

{% docs shared__stg_substitution_rules__unavailable_product_id %}
Source-system identifier for the unavailable product.
{% enddocs %}

{% docs shared__stg_substitution_rules__substitute_product_id %}
Source-system identifier for the substitute product.
{% enddocs %}

{% docs shared__stg_substitution_rules__priority_rank %}
Priority rank recorded on the substitution rules record after type and naming normalization.
{% enddocs %}

{% docs shared__stg_substitution_rules__effective_from_utc %}
UTC timestamp at which the record becomes effective.
{% enddocs %}

{% docs shared__stg_substitution_rules__effective_to_utc %}
UTC timestamp at which the record stops being effective; null means open-ended.
{% enddocs %}

{% docs shared__stg_substitution_rules__reason_code %}
Normalized business reason explaining why the paired product is an acceptable substitute.
{% enddocs %}
