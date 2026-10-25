{% for input in settlement_inputs('settlement_events') %}
select * from {{ ref(input) }}
{% if not loop.last %}union all{% endif %}
{% endfor %}
