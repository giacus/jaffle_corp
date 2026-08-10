{% docs merchandising__int_basket_pair_observations %}
Intermediate model for `int_basket_pair_observations` transformation logic.
{% enddocs %}

{% docs merchandising__int_basket_pair_observations__basket_pair_observation_key %}
Stable key identifying a row produced by `int_basket_pair_observations`. Derived from order id, anchor product id, and paired product id.
{% enddocs %}

{% docs merchandising__int_basket_pair_observations__paired_item_total_major %}
The paired item total major value produced for each `int_basket_pair_observations` row. Derived from anchor item total major.
{% enddocs %}

{% docs merchandising__int_basket_pair_observations__is_curated_pair %}
Whether the product-pair affinity fact at product-pair-day grain represents curated pair. Derived from pairing identifier.
{% enddocs %}
