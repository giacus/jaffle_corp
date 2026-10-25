{% macro gateway_settlements(source_name, table_name) %}
    {{ return(builtins.source(source_name, table_name)) }}
{% endmacro %}

{% macro settlement_input_models(primary_model_name) %}
    {% set input_models = [primary_model_name] %}
    {% for model_name in varargs %}
        {% do input_models.append(model_name) %}
    {% endfor %}
    {{ return(input_models) }}
{% endmacro %}

{% macro settlement_input(model_name) %}
    {% set resolvers = builtins %}
    {% set resolve_model = resolvers.ref %}
    {% set selected = namespace(model_name='stg_settlement_events') %}
    {% for candidate in [model_name] %}
        {% set selected.model_name = candidate %}
    {% endfor %}
    {{ return(resolve_model(selected.model_name)) }}
{% endmacro %}
