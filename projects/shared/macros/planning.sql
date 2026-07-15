{% macro week_start(date_expr) %}
    cast(date_trunc('week', cast({{ date_expr }} as date)) as date)
{% endmacro %}

{% macro hour_start(timestamp_expr) %}
    cast(date_trunc('hour', cast({{ timestamp_expr }} as timestamp)) as timestamp)
{% endmacro %}

{% macro forecast_error(actual_expr, forecast_expr) %}
    cast({{ actual_expr }} as double) - cast({{ forecast_expr }} as double)
{% endmacro %}

{% macro absolute_forecast_error(actual_expr, forecast_expr) %}
    abs({{ jaffle_shared.forecast_error(actual_expr, forecast_expr) }})
{% endmacro %}

{% macro forecast_accuracy_band(absolute_percentage_error_expr) %}
    case
        when {{ absolute_percentage_error_expr }} is null then 'not_scored'
        when {{ absolute_percentage_error_expr }} <= 0.10 then 'inside_10_percent'
        when {{ absolute_percentage_error_expr }} <= 0.25 then 'inside_25_percent'
        else 'outside_25_percent'
    end
{% endmacro %}

{% macro plan_variance_status(actual_expr, planned_expr, tolerance_expr='0.10') %}
    case
        when {{ planned_expr }} is null or {{ planned_expr }} = 0 then 'not_scored'
        when abs(cast({{ actual_expr }} as double) - cast({{ planned_expr }} as double))
            / abs(cast({{ planned_expr }} as double)) <= {{ tolerance_expr }} then 'inside_tolerance'
        when cast({{ actual_expr }} as double) > cast({{ planned_expr }} as double) then 'over_plan'
        else 'under_plan'
    end
{% endmacro %}
