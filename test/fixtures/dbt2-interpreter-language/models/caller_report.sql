{% call render_settlement_report() %}
select * from {{ ref('settlement_events') }}
{% endcall %}
