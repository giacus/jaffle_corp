{% macro legacy_status_bucket(status_expr) %}
    case
        when lower({{ status_expr }}) in ('completed', 'served', 'fulfilled') then 'good'
        when lower({{ status_expr }}) in ('cancelled', 'failed') then 'bad'
        when lower({{ status_expr }}) = 'refunded' then 'messy'
        else 'maybe'
    end
{% endmacro %}

