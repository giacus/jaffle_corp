{% macro store_reliability_at(store_expression, date_expression) %}
    {{
        return(
            function('current_store_reliability')
            ~ '(' ~ store_expression ~ ', ' ~ date_expression ~ ')'
        )
    }}
{% endmacro %}

{% macro reliability_input_readiness() %}
    {% set finance_relation = ref('finance', 'fct_store_day_revenue_quality') %}
    {% set merchandising_relation = ref('merchandising', 'fct_product_store_day_availability') %}
    {% set planning_relation = ref('planning', 'fct_store_day_capacity_plan') %}

    {% if execute %}
        {% set finance_ready = load_relation(finance_relation) is not none %}
        {% set merchandising_ready = load_relation(merchandising_relation) is not none %}
        {% set planning_ready = load_relation(planning_relation) is not none %}
    {% else %}
        {% set finance_ready = false %}
        {% set merchandising_ready = false %}
        {% set planning_ready = false %}
    {% endif %}

    {% if execute and project_name == 'reliability' %}
        {% set missing_inputs = [] %}
        {% if not finance_ready %}
            {% do missing_inputs.append('finance.fct_store_day_revenue_quality') %}
        {% endif %}
        {% if not merchandising_ready %}
            {% do missing_inputs.append('merchandising.fct_product_store_day_availability') %}
        {% endif %}
        {% if not planning_ready %}
            {% do missing_inputs.append('planning.fct_store_day_capacity_plan') %}
        {% endif %}

        {% if missing_inputs %}
            {{
                exceptions.raise_compiler_error(
                    'Reliability requires these public upstream models before it can run: '
                    ~ missing_inputs | join(', ')
                    ~ '. Run scripts/validate_repo.sh from the repository root first.'
                )
            }}
        {% endif %}
    {% endif %}

    select
        'finance_revenue_quality' as input_name,
        {{ finance_ready | lower }} as is_available
    union all
    select
        'merchandising_product_availability' as input_name,
        {{ merchandising_ready | lower }} as is_available
    union all
    select
        'planning_capacity_plan' as input_name,
        {{ planning_ready | lower }} as is_available
{% endmacro %}
