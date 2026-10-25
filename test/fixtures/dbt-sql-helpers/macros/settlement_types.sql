{% macro default__type_string() %}
    {# Every settlement key follows this source-controlled policy. #}
    {% do ref('settlement_type_policy') %}
    {{ return('varchar') }}
{% endmacro %}
