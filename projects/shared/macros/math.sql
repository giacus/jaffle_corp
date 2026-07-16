{% macro safe_divide(numerator_expr, denominator_expr) %}
    case
        when {{ denominator_expr }} is null or {{ denominator_expr }} = 0 then null
        else cast({{ numerator_expr }} as double) / cast({{ denominator_expr }} as double)
    end
{% endmacro %}

{% macro bounded_ratio(numerator_expr, denominator_expr) %}
    least(1.0, greatest(0.0, coalesce({{ shared.safe_divide(numerator_expr, denominator_expr) }}, 0.0)))
{% endmacro %}
