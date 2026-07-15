{% docs jaffle_merchandising__fct_basket_pair_affinity %}
Public product-pair affinity fact at product-pair-day grain.
{% enddocs %}

{% docs merchandising__fct_basket_pair_affinity__basket_pair_affinity_key %}
Deterministic surrogate key for the product-pair affinity fact at product-pair-day grain. Derived from anchor product identifier, paired product identifier, and ordered date UTC.
{% enddocs %}

{% docs merchandising__fct_basket_pair_affinity__paired_order_count %}
Number of paired orders represented by the product-pair affinity fact at product-pair-day grain. Aggregated from order identifier.
{% enddocs %}

{% docs merchandising__fct_basket_pair_affinity__paired_item_total_major %}
Paired item total for the product-pair affinity fact at product-pair-day grain, expressed in currency major units.
{% enddocs %}
