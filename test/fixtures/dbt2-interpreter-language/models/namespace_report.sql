{% set inputs = namespace() %}
{% set inputs.primary = namespace(name='settlement_events') %}
{{ config(tags=['settlements']) }}
select * from {{ ref(inputs.primary.get('name')) }}
