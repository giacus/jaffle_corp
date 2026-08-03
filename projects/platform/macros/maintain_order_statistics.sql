{% macro maintain_order_statistics() %}
    {% set order_relation = ref('fct_orders') %}

    {% if project_name == 'platform' %}
        {% set existing_relation = load_relation(order_relation) if execute else none %}
        {% if existing_relation is not none %}
            analyze {{ existing_relation }}
        {% else %}
            select 'Order statistics will be refreshed after fct_orders is available' as maintenance_status
        {% endif %}
    {% else %}
        select 'Order statistics maintenance is owned by the Platform project' as maintenance_status
    {% endif %}
{% endmacro %}

{% macro report_platform_input_readiness() %}
    {% set raw_orders_relation = source('platform_app', 'raw_orders') %}
    {% set input_status = 'managed_by_platform' %}

    {% if execute and project_name == 'platform' %}
        {% set raw_orders_available = load_relation(raw_orders_relation) is not none %}
        {% if raw_orders_available %}
            {% set input_status = 'available' %}
            {% do log('Platform raw orders are available before this command.', info=true) %}
        {% else %}
            {% set input_status = 'awaiting_seed' %}
            {% do log('Platform raw orders are not loaded yet; the seed command can create them.', info=true) %}
        {% endif %}
    {% endif %}

    select '{{ input_status }}' as raw_order_input_status
{% endmacro %}
