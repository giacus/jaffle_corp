{% docs merchandising__stg_product_pairings %}
Staging model for `stg_product_pairings` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_product_pairings__pairing_id %}
Source-system identifier for the pairing.
{% enddocs %}

{% docs shared__stg_product_pairings__anchor_product_id %}
Source-system identifier for the anchor product.
{% enddocs %}

{% docs shared__stg_product_pairings__paired_product_id %}
Source-system identifier for the paired product.
{% enddocs %}

{% docs shared__stg_product_pairings__pairing_reason %}
Normalized business classification for pairing reason.
{% enddocs %}

{% docs shared__stg_product_pairings__effective_from_utc %}
UTC timestamp at which the record becomes effective.
{% enddocs %}

{% docs shared__stg_product_pairings__effective_to_utc %}
UTC timestamp at which the record stops being effective; null means open-ended.
{% enddocs %}

{% docs shared__stg_product_pairings__pairing_rank %}
Priority rank of the paired product recommendation.
{% enddocs %}
