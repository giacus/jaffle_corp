{% macro audit_prefers_full_rebuild() %}
  {% if target.type in ('databricks', 'spark') %}
    {{ return(true) }}
  {% endif %}
  {{ return(var('audit_force_full_rebuild', false)) }}
{% endmacro %}
