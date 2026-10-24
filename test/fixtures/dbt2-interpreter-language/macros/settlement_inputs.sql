{% macro settlement_input() %}
    {{ return(kwargs.pop('name', 'settlement_events')) }}
{% endmacro %}

{% macro settlement_inputs() %}
    {% set inputs = varargs[:] %}
    {% do inputs.append('settlement_adjustments') %}
    {{ return(inputs) }}
{% endmacro %}

{% macro render_settlement_report() %}
    {{ caller() }}
{% endmacro %}
