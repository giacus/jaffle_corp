{% macro window_start(column_expr, hours_back_var='window_hours_back') %}
    {{ column_expr }} >= (
        cast('{{ var("data_interval_start", "2026-01-01 00:00:00") }}' as timestamp)
        - interval '{{ var(hours_back_var, 0) }} hours'
    )
{% endmacro %}

{% macro window_end(column_expr) %}
    {{ column_expr }} < cast('{{ var("data_interval_end", "2026-01-02 00:00:00") }}' as timestamp)
{% endmacro %}

{% macro in_processing_window(column_expr, hours_back_var='window_hours_back') %}
    {{ window_start(column_expr, hours_back_var) }}
    and {{ window_end(column_expr) }}
{% endmacro %}

