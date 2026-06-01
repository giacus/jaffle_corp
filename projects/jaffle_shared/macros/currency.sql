{% macro minor_units_to_major_units(amount_expr, scale=100) %}
    cast({{ amount_expr }} as double) / {{ scale }}
{% endmacro %}

{% macro fx_to_usd(amount_expr, currency_expr, fx_rate_expr) %}
    case
        when {{ currency_expr }} = 'USD' then cast({{ amount_expr }} as double)
        when {{ fx_rate_expr }} is null then null
        else cast({{ amount_expr }} as double) * cast({{ fx_rate_expr }} as double)
    end
{% endmacro %}

{% macro signed_amount(amount_expr, direction_expr) %}
    case
        when lower({{ direction_expr }}) in ('refund', 'reversal', 'credit') then -1 * {{ amount_expr }}
        else {{ amount_expr }}
    end
{% endmacro %}

