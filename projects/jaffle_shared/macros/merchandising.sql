{% macro availability_status(status_expr) %}
    case
        when lower({{ status_expr }}) in ('available', 'featured') then 'available'
        when lower({{ status_expr }}) in ('limited', 'low_stock') then 'limited'
        when lower({{ status_expr }}) in ('paused', 'unavailable') then 'unavailable'
        else 'unknown'
    end
{% endmacro %}

{% macro availability_health(status_expr, expected_units_expr, observed_units_expr) %}
    case
        when {{ status_expr }} = 'unavailable' then 'blocked'
        when {{ observed_units_expr }} is null then 'missing_observation'
        when {{ observed_units_expr }} < {{ expected_units_expr }} * 0.50 then 'thin'
        when {{ observed_units_expr }} < {{ expected_units_expr }} then 'watch'
        else 'healthy'
    end
{% endmacro %}

{% macro menu_price_band(price_minor_expr) %}
    case
        when {{ price_minor_expr }} is null then 'missing'
        when {{ price_minor_expr }} < 800 then 'entry'
        when {{ price_minor_expr }} < 1200 then 'core'
        else 'premium'
    end
{% endmacro %}

{% macro goal_attainment_status(attainment_expr) %}
    case
        when {{ attainment_expr }} is null then 'not_scored'
        when {{ attainment_expr }} >= 1.00 then 'met'
        when {{ attainment_expr }} >= 0.80 then 'near'
        else 'behind'
    end
{% endmacro %}
