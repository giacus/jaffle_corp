{% set exact_external_id = fromjson('9007199254740993') %}
select * from {{ ref('settlement_adjustments' if exact_external_id != 9007199254740992 else 'settlement_events') }}
