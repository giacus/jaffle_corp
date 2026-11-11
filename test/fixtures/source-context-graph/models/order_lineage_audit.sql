{% if var('orders_relation_override', none) is not none %}
-- depends_on: {{ ref('expedited_orders') }}
{% else %}
-- depends_on: {{ ref('stg_orders') }}
{% endif %}

{% if execute and flags.WHICH in ('run', 'build') %}
  {% if var('orders_relation_override', none) is not none %}
    {% set audit_relation = ref('expedited_orders') %}
  {% else %}
    {% set audit_relation = ref('stg_orders') %}
  {% endif %}
{% endif %}

select {{ dbt.current_timestamp_backcompat() }} as audited_at
