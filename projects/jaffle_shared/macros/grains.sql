{% macro store_day_key(store_expr, date_expr) %}
    {{ jaffle_shared.stable_hash([store_expr, date_expr]) }}
{% endmacro %}

{% macro product_store_day_key(product_expr, store_expr, date_expr) %}
    {{ jaffle_shared.stable_hash([product_expr, store_expr, date_expr]) }}
{% endmacro %}

{% macro store_hour_key(store_expr, hour_expr) %}
    {{ jaffle_shared.stable_hash([store_expr, hour_expr]) }}
{% endmacro %}

{% macro product_store_hour_key(product_expr, store_expr, hour_expr) %}
    {{ jaffle_shared.stable_hash([product_expr, store_expr, hour_expr]) }}
{% endmacro %}

{% macro product_day_key(product_expr, date_expr) %}
    {{ jaffle_shared.stable_hash([product_expr, date_expr]) }}
{% endmacro %}

{% macro component_store_week_key(component_expr, store_expr, week_expr) %}
    {{ jaffle_shared.stable_hash([component_expr, store_expr, week_expr]) }}
{% endmacro %}

{% macro scenario_store_day_key(scenario_expr, store_expr, date_expr) %}
    {{ jaffle_shared.stable_hash([scenario_expr, store_expr, date_expr]) }}
{% endmacro %}
