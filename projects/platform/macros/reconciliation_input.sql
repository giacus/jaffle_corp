{% macro reconciliation_input() %}
  {{ return(adapter.dispatch('reconciliation_input', 'platform')()) }}
{% endmacro %}

{% macro default__reconciliation_input() %}
  {{ return(ref('stg_payments')) }}
{% endmacro %}

{% macro duckdb__reconciliation_input() %}
  {% if target.name == 'dev' %}
    {{ return(ref('stg_orders')) }}
  {% else %}
    {{ return(ref('stg_payments')) }}
  {% endif %}
{% endmacro %}
