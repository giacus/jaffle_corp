{% macro audit_noop() %}
    select 1 as audit_marker
{% endmacro %}

{% test accepted_not_unknown(model, column_name) %}
    select *
    from {{ model }}
    where lower(cast({{ column_name }} as varchar)) in ('unknown', 'n/a', '')
{% endtest %}

