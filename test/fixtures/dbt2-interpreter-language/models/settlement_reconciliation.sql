{% macro settlement_adjustment_status(column_name, tolerance_cents) -%}
    case
        when abs({{ column_name }}) <= {{ tolerance_cents }} then 'within_tolerance'
        else 'review'
    end
{%- endmacro %}

{% set channel_tolerances = [
    ('capture', 0),
    ('adjustment', 5),
    ('policy', 100)
] %}
{% set selected_channels = 'capture|adjustment'.split('|') %}
{% set selected_tolerances = [] %}
{% for channel, tolerance_cents in channel_tolerances if channel in selected_channels %}
    {% do selected_tolerances.append(tolerance_cents) %}
{% endfor %}
{% set adjustment_tolerance_cents = selected_tolerances | sum %}

with settlement_entries as (
    {{ settlement_channel_rows('capture|adjustment') }}
),
settlement_totals as (
    select
        settlement_id,
        sum(case when entry_type = 'capture' then amount_cents else 0 end) as captured_cents,
        sum(case when entry_type = 'adjustment' then amount_cents else 0 end) as adjustment_cents
    from settlement_entries
    group by settlement_id
)

select
    settlement_id,
    captured_cents,
    adjustment_cents,
    captured_cents + adjustment_cents as net_amount_cents,
    {{ adjustment_tolerance_cents }} as adjustment_tolerance_cents,
    {{ settlement_adjustment_status('adjustment_cents', adjustment_tolerance_cents) }} as adjustment_status
from settlement_totals
