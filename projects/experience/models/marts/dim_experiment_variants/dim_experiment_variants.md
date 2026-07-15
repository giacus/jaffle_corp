{% docs jaffle_experience__dim_experiment_variants %}
Public experiment-variant dimension.
{% enddocs %}

{% docs experience__dim_experiment_variants__experiment_variant_key %}
Deterministic surrogate key for the experiment-variant dimension. Derived from experiment identifier and variant identifier.
{% enddocs %}

{% docs experience__dim_experiment_variants__first_exposed_at_utc %}
Earliest UTC timestamp for exposed on the experiment-variant dimension. Aggregated from exposed at UTC.
{% enddocs %}

{% docs experience__dim_experiment_variants__most_recent_exposed_at_utc %}
Most recent UTC timestamp for exposed on the experiment-variant dimension. Aggregated from exposed at UTC.
{% enddocs %}

{% docs experience__dim_experiment_variants__exposure_count %}
Number of exposures represented by the experiment-variant dimension. Aggregated from exposure identifier.
{% enddocs %}

{% docs experience__dim_experiment_variants__price_test_count %}
Number of price tests represented by the experiment-variant dimension. Aggregated from price test identifier.
{% enddocs %}

{% docs experience__dim_experiment_variants__surfaces %}
Surfaces represented by the experiment-variant dimension. Aggregated from surface.
{% enddocs %}
