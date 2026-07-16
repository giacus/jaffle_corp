{% docs merchandising__int_substitution_coverage %}
Intermediate model for `int_substitution_coverage` transformation logic.
{% enddocs %}

{% docs merchandising__int_substitution_coverage__substitution_coverage_key %}
Deterministic surrogate key for the substitution-rule readiness fact at rule-day grain. Derived from substitution rule identifier and available date UTC.
{% enddocs %}

{% docs merchandising__int_substitution_coverage__unavailable_product_name %}
Unavailable product name represented by the substitution-rule readiness fact at rule-day grain. Derived from product name.
{% enddocs %}

{% docs merchandising__int_substitution_coverage__substitute_product_name %}
Substitute product name represented by the substitution-rule readiness fact at rule-day grain. Derived from product name.
{% enddocs %}

{% docs merchandising__int_substitution_coverage__rule_was_needed %}
Rule was needed represented by the substitution-rule readiness fact at rule-day grain. Derived from product store day status.
{% enddocs %}

{% docs merchandising__int_substitution_coverage__substitute_is_published %}
Substitute is published represented by the substitution-rule readiness fact at rule-day grain. Derived from product identifier.
{% enddocs %}
