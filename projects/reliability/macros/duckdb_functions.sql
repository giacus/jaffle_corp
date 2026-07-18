{% macro duckdb__scalar_function_sql(target_relation) %}
    create or replace macro {{ target_relation.render() }} (
        {%- for argument in model.arguments -%}
            {{ argument.name }}{% if not loop.last %}, {% endif %}
        {%- endfor -%}
    ) as (
        {{ model.compiled_code }}
    )
{% endmacro %}
