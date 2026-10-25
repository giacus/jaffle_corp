{% macro settlement_channel_rows(channel_selector) %}
    {% set selected_channels = channel_selector.split('|') %}
    {% set available_channels = [
        ('capture', 'settlement_events'),
        ('adjustment', 'settlement_adjustments'),
        ('policy', 'settlement_type_policy')
    ] %}
    {% for channel, relation_name in available_channels if channel in selected_channels %}
        select '{{ channel }}' as entry_type, settlement_id, amount_cents
        from {{ ref(relation_name) }}
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
{% endmacro %}
