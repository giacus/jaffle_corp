{% set message_result = print('Preparing the settlement report') %}
{% if message_result is string %}
  {% set input_name = log(ref('settlement_events'), info=true) ~ 'positive_settlement_events' %}
{% else %}
  {% set input_name = 'invalid_logging_result' %}
{% endif %}
select * from {{ ref(input_name) }}
