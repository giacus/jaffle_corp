{{ builtins.config(
    materialized='table',
    tags=['settlement_reconciliation'],
    pre_hook="select count(*) from {{ builtins.source('settlement_gateway', 'raw_settlement_events') }}"
) }}

{# Older runtimes expose a print flag; native dbt 2 leaves it undefined. #}
{% if flags.PRINT is defined %}
    {% do log('Positive settlement input: ' ~ builtins.ref('positive_settlement_events'), info=true) %}
{% endif %}

select
    customer_id,
    count(*) as settlement_event_count,
    sum(settled_amount) as settled_amount_total
from {{ settlement_input(env_var('JAFFLE_SETTLEMENT_INPUT', 'stg_settlement_events')) }}
group by customer_id
