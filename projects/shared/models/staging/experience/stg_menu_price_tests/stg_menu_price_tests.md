{% docs experience__stg_menu_price_tests %}
Staging model for `stg_menu_price_tests` source cleanup and normalization.
{% enddocs %}

{% docs shared__stg_menu_price_tests__price_test_id %}
Source-system identifier for the price test.
{% enddocs %}

{% docs shared__stg_menu_price_tests__effective_from_utc %}
UTC timestamp at which the `stg_menu_price_tests` record becomes effective.
{% enddocs %}

{% docs shared__stg_menu_price_tests__effective_to_utc %}
UTC timestamp at which the `stg_menu_price_tests` record stops being effective; null means open-ended.
{% enddocs %}

{% docs shared__stg_menu_price_tests__list_price_minor %}
List price tested for the product-store experiment, expressed in the source currency minor unit.
{% enddocs %}

{% docs shared__stg_menu_price_tests__list_price_major %}
List price expressed in the source currency major unit.
{% enddocs %}

{% docs shared__stg_menu_price_tests__updated_at_utc %}
UTC timestamp when the source system last updated the `stg_menu_price_tests` record.
{% enddocs %}
