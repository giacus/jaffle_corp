{{ builtins.config(tags=['settlement_reconciliation']) }}

{% set decode = fromjson %}
{% set input_spec = decode('{"model":"stg_settlement_events","suffix":"_validated"}') %}
{% set validated_input = builtins.ref(input_spec.model).identifier ~ input_spec.suffix %}
{% set gateway_seed = builtins.source('settlement_gateway', 'raw_settlement_events').identifier %}

{% for input_model in settlement_input_models(validated_input, 'positive_settlement_events') %}
select
    '{{ input_model }}' as input_name,
    count(*) as settlement_event_count
from {{ builtins.ref(input_model) }}
union all
{% endfor %}
select
    'gateway_seed' as input_name,
    count(*) as settlement_event_count
from {{ builtins.ref(gateway_seed) }}
