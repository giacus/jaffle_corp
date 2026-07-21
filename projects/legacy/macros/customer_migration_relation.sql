{% macro customer_migration_relation(version=none) %}
    {% set model_name = var('legacy_customer_model') %}

    {% if version is none %}
        {{ return(ref(model_name)) }}
    {% endif %}

    {{ return(ref(model_name, version=version)) }}
{% endmacro %}

{% macro stable_customer_migration_relation() %}
    {{ return(customer_migration_relation(version=1)) }}
{% endmacro %}

{% macro current_customer_migration_relation() %}
    {{ return(customer_migration_relation()) }}
{% endmacro %}
