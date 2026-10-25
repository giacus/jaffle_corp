{% set events = ref('settlement_events') %}
{% set adjustments = events.incorporate(path={'identifier': 'settlement_adjustments'}) %}
select * from {{ ref(adjustments.quote(identifier=true).identifier) }}
