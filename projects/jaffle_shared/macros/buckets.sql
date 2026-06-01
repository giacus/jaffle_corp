{% macro minutes_between(start_expr, end_expr) %}
    date_diff('minute', cast({{ start_expr }} as timestamp), cast({{ end_expr }} as timestamp))
{% endmacro %}

{% macro bucket_minutes(minutes_expr) %}
    case
        when {{ minutes_expr }} is null then 'missing'
        when {{ minutes_expr }} < 0 then 'invalid'
        when {{ minutes_expr }} <= 5 then '0_to_5'
        when {{ minutes_expr }} <= 15 then '6_to_15'
        when {{ minutes_expr }} <= 30 then '16_to_30'
        else 'over_30'
    end
{% endmacro %}

{% macro sla_status(minutes_expr, target_minutes) %}
    case
        when {{ minutes_expr }} is null then 'missing'
        when {{ minutes_expr }} < 0 then 'invalid'
        when {{ minutes_expr }} <= {{ target_minutes }} then 'within_target'
        else 'outside_target'
    end
{% endmacro %}

