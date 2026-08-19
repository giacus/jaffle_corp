{% macro order_ingestion_reconciliation() %}
    {{ return(shared.platform_ingestion_reconciliation('raw_orders', 'stg_orders')) }}
{% endmacro %}

{% macro platform_ingestion_feed_specs() %}
    {#
      Include platform feeds only when raw and staged rows retain comparable
      grains. Relation names follow the shared raw_<subject>/stg_<subject>
      convention so one inventory can drive both dependency calls.
    #}
    {{
        return([
            {
                'feed_name': 'orders',
                'subject': 'orders',
                'review_window_minutes': 30
            },
            {
                'feed_name': 'customers',
                'subject': 'customers',
                'review_window_minutes': 90
            }
        ])
    }}
{% endmacro %}

{% macro platform_ingestion_relation_name(layer_prefix, subject) %}
    {{ return(layer_prefix ~ '_' ~ subject) }}
{% endmacro %}

{% macro platform_ingestion_review_window_policies() %}
    {#
      Keep the minute-level policy explicit so ingestion operators can inspect
      the exact review band applied to any configured feed window.
    #}
    {{
        return({
            '0': 'immediate',
            '1': 'immediate',
            '2': 'immediate',
            '3': 'immediate',
            '4': 'immediate',
            '5': 'immediate',
            '6': 'immediate',
            '7': 'immediate',
            '8': 'immediate',
            '9': 'immediate',
            '10': 'immediate',
            '11': 'immediate',
            '12': 'immediate',
            '13': 'immediate',
            '14': 'immediate',
            '15': 'immediate',
            '16': 'same_hour',
            '17': 'same_hour',
            '18': 'same_hour',
            '19': 'same_hour',
            '20': 'same_hour',
            '21': 'same_hour',
            '22': 'same_hour',
            '23': 'same_hour',
            '24': 'same_hour',
            '25': 'same_hour',
            '26': 'same_hour',
            '27': 'same_hour',
            '28': 'same_hour',
            '29': 'same_hour',
            '30': 'same_hour',
            '31': 'same_hour',
            '32': 'same_hour',
            '33': 'same_hour',
            '34': 'same_hour',
            '35': 'same_hour',
            '36': 'same_hour',
            '37': 'same_hour',
            '38': 'same_hour',
            '39': 'same_hour',
            '40': 'same_hour',
            '41': 'same_hour',
            '42': 'same_hour',
            '43': 'same_hour',
            '44': 'same_hour',
            '45': 'same_hour',
            '46': 'same_hour',
            '47': 'same_hour',
            '48': 'same_hour',
            '49': 'same_hour',
            '50': 'same_hour',
            '51': 'same_hour',
            '52': 'same_hour',
            '53': 'same_hour',
            '54': 'same_hour',
            '55': 'same_hour',
            '56': 'same_hour',
            '57': 'same_hour',
            '58': 'same_hour',
            '59': 'same_hour',
            '60': 'same_hour',
            '61': 'same_shift',
            '62': 'same_shift',
            '63': 'same_shift',
            '64': 'same_shift',
            '65': 'same_shift',
            '66': 'same_shift',
            '67': 'same_shift',
            '68': 'same_shift',
            '69': 'same_shift',
            '70': 'same_shift',
            '71': 'same_shift',
            '72': 'same_shift',
            '73': 'same_shift',
            '74': 'same_shift',
            '75': 'same_shift',
            '76': 'same_shift',
            '77': 'same_shift',
            '78': 'same_shift',
            '79': 'same_shift',
            '80': 'same_shift',
            '81': 'same_shift',
            '82': 'same_shift',
            '83': 'same_shift',
            '84': 'same_shift',
            '85': 'same_shift',
            '86': 'same_shift',
            '87': 'same_shift',
            '88': 'same_shift',
            '89': 'same_shift',
            '90': 'same_shift',
            '91': 'same_shift',
            '92': 'same_shift',
            '93': 'same_shift',
            '94': 'same_shift',
            '95': 'same_shift',
            '96': 'same_shift',
            '97': 'same_shift',
            '98': 'same_shift',
            '99': 'same_shift',
            '100': 'same_shift',
            '101': 'same_shift',
            '102': 'same_shift',
            '103': 'same_shift',
            '104': 'same_shift',
            '105': 'same_shift',
            '106': 'same_shift',
            '107': 'same_shift',
            '108': 'same_shift',
            '109': 'same_shift',
            '110': 'same_shift',
            '111': 'same_shift',
            '112': 'same_shift',
            '113': 'same_shift',
            '114': 'same_shift',
            '115': 'same_shift',
            '116': 'same_shift',
            '117': 'same_shift',
            '118': 'same_shift',
            '119': 'same_shift',
            '120': 'same_shift',
            '121': 'same_shift',
            '122': 'same_shift',
            '123': 'same_shift',
            '124': 'same_shift',
            '125': 'same_shift',
            '126': 'same_shift',
            '127': 'same_shift',
            '128': 'same_shift',
            '129': 'same_shift',
            '130': 'same_shift',
            '131': 'same_shift',
            '132': 'same_shift',
            '133': 'same_shift',
            '134': 'same_shift',
            '135': 'same_shift',
            '136': 'same_shift',
            '137': 'same_shift',
            '138': 'same_shift',
            '139': 'same_shift',
            '140': 'same_shift',
            '141': 'same_shift',
            '142': 'same_shift',
            '143': 'same_shift',
            '144': 'same_shift',
            '145': 'same_shift',
            '146': 'same_shift',
            '147': 'same_shift',
            '148': 'same_shift',
            '149': 'same_shift',
            '150': 'same_shift',
            '151': 'same_shift',
            '152': 'same_shift',
            '153': 'same_shift',
            '154': 'same_shift',
            '155': 'same_shift',
            '156': 'same_shift',
            '157': 'same_shift',
            '158': 'same_shift',
            '159': 'same_shift',
            '160': 'same_shift',
            '161': 'same_shift',
            '162': 'same_shift',
            '163': 'same_shift',
            '164': 'same_shift',
            '165': 'same_shift',
            '166': 'same_shift',
            '167': 'same_shift',
            '168': 'same_shift',
            '169': 'same_shift',
            '170': 'same_shift',
            '171': 'same_shift',
            '172': 'same_shift',
            '173': 'same_shift',
            '174': 'same_shift',
            '175': 'same_shift',
            '176': 'same_shift',
            '177': 'same_shift',
            '178': 'same_shift',
            '179': 'same_shift',
            '180': 'same_shift',
            '181': 'next_review_cycle',
            '182': 'next_review_cycle',
            '183': 'next_review_cycle',
            '184': 'next_review_cycle',
            '185': 'next_review_cycle',
            '186': 'next_review_cycle',
            '187': 'next_review_cycle',
            '188': 'next_review_cycle',
            '189': 'next_review_cycle',
            '190': 'next_review_cycle',
            '191': 'next_review_cycle',
            '192': 'next_review_cycle',
            '193': 'next_review_cycle',
            '194': 'next_review_cycle',
            '195': 'next_review_cycle',
            '196': 'next_review_cycle',
            '197': 'next_review_cycle',
            '198': 'next_review_cycle',
            '199': 'next_review_cycle',
            '200': 'next_review_cycle',
            '201': 'next_review_cycle',
            '202': 'next_review_cycle',
            '203': 'next_review_cycle',
            '204': 'next_review_cycle',
            '205': 'next_review_cycle',
            '206': 'next_review_cycle',
            '207': 'next_review_cycle',
            '208': 'next_review_cycle',
            '209': 'next_review_cycle',
            '210': 'next_review_cycle',
            '211': 'next_review_cycle',
            '212': 'next_review_cycle',
            '213': 'next_review_cycle',
            '214': 'next_review_cycle',
            '215': 'next_review_cycle',
            '216': 'next_review_cycle',
            '217': 'next_review_cycle',
            '218': 'next_review_cycle',
            '219': 'next_review_cycle',
            '220': 'next_review_cycle',
            '221': 'next_review_cycle',
            '222': 'next_review_cycle',
            '223': 'next_review_cycle',
            '224': 'next_review_cycle',
            '225': 'next_review_cycle',
            '226': 'next_review_cycle',
            '227': 'next_review_cycle',
            '228': 'next_review_cycle',
            '229': 'next_review_cycle',
            '230': 'next_review_cycle',
            '231': 'next_review_cycle',
            '232': 'next_review_cycle',
            '233': 'next_review_cycle',
            '234': 'next_review_cycle',
            '235': 'next_review_cycle',
            '236': 'next_review_cycle',
            '237': 'next_review_cycle',
            '238': 'next_review_cycle',
            '239': 'next_review_cycle',
            '240': 'next_review_cycle',
            '241': 'next_review_cycle',
            '242': 'next_review_cycle',
            '243': 'next_review_cycle',
            '244': 'next_review_cycle',
            '245': 'next_review_cycle',
            '246': 'next_review_cycle',
            '247': 'next_review_cycle',
            '248': 'next_review_cycle',
            '249': 'next_review_cycle',
            '250': 'next_review_cycle',
            '251': 'next_review_cycle',
            '252': 'next_review_cycle',
            '253': 'next_review_cycle',
            '254': 'next_review_cycle',
            '255': 'next_review_cycle',
            '256': 'next_review_cycle'
        })
    }}
{% endmacro %}

{% macro platform_ingestion_review_band(review_window_minutes) %}
    {% set policies = shared.platform_ingestion_review_window_policies() %}
    {% set review_window_key = review_window_minutes | string %}

    {% for policy_key in policies %}
        {% if policy_key == review_window_key %}
            {{ return(policies[policy_key]) }}
        {% endif %}
    {% endfor %}

    {{ return('unclassified') }}
{% endmacro %}

{% macro platform_ingestion_scheduled_review_windows(review_bands, feed_scope) %}
    {#
      Materialize the complete set of active review windows once so scheduled
      reconciliations can apply the same operating policy to every feed. An
      omitted feed scope represents the default all-feed schedule.
    #}
    {% set policies = shared.platform_ingestion_review_window_policies() %}
    {% set scheduled_review_windows = [] %}

    {% for review_window, review_band in policies.items() %}
        {% if review_band in review_bands and feed_scope not in ('paused', 'retired') %}
            {% do scheduled_review_windows.append(review_window) %}
        {% endif %}
    {% endfor %}

    {{ return(scheduled_review_windows) }}
{% endmacro %}

{% macro platform_ingestion_scheduled_volume_reconciliation(review_bands, feed_scope) %}
    {% set scheduled_review_windows =
        shared.platform_ingestion_scheduled_review_windows(review_bands) %}

    {% for feed in shared.platform_ingestion_feed_specs() %}
        {% set review_window_key = feed.get('review_window_minutes', 0) | string %}

        {% if review_window_key in scheduled_review_windows %}
            {% if not loop.first %}
                union all
            {% endif %}

            {{
                shared.render_platform_ingestion_volume_reconciliation(
                    feed.feed_name,
                    shared.platform_ingestion_relation_name('raw', feed.subject),
                    shared.platform_ingestion_relation_name('stg', feed.subject),
                    shared.platform_ingestion_review_band(feed.review_window_minutes)
                )
            }}
        {% endif %}
    {% endfor %}
{% endmacro %}

{% macro platform_ingestion_volume_reconciliation() %}
    {% for feed in shared.platform_ingestion_feed_specs() %}
        {% set review_band = shared.platform_ingestion_review_band(feed.review_window_minutes) %}

        {% if not loop.first %}
            union all
        {% endif %}

        {{
            shared.render_platform_ingestion_volume_reconciliation(
                feed.feed_name,
                shared.platform_ingestion_relation_name('raw', feed.subject),
                shared.platform_ingestion_relation_name('stg', feed.subject),
                review_band
            )
        }}
    {% endfor %}
{% endmacro %}

{% macro render_platform_ingestion_volume_reconciliation(
    feed_name,
    raw_table_name,
    staged_model_name,
    review_band
) %}
    {% set raw_relation = source('platform_app', raw_table_name) %}
    {% set staged_relation = ref(staged_model_name) %}

    select
        '{{ feed_name }}' as feed_name,
        '{{ review_band }}' as review_band,
        raw_row_count,
        normalized_row_count,
        normalized_row_count - raw_row_count as row_count_delta
    from (
        select
            (select count(*) from {{ raw_relation }}) as raw_row_count,
            (select count(*) from {{ staged_relation }}) as normalized_row_count
    ) as feed_volumes
{% endmacro %}

{% macro platform_ingestion_reconciliation(raw_table_name, staged_model_name) %}
    {{
        return(
            adapter.dispatch(
                'render_platform_ingestion_reconciliation',
                'shared'
            )(raw_table_name, staged_model_name)
        )
    }}
{% endmacro %}

{% macro default__render_platform_ingestion_reconciliation(raw_table_name, staged_model_name) %}
    {% set raw_relation = source('platform_app', raw_table_name) %}
    {% set staged_relation = ref(staged_model_name) %}

    with raw_feed as (
        select cast(order_id as varchar) as order_id
        from {{ raw_relation }}
    ),

    normalized_orders as (
        select
            order_id,
            order_status
        from {{ staged_relation }}
    )

    select
        count(raw_feed.order_id) as raw_order_count,
        count(normalized_orders.order_id) as normalized_order_count,
        sum(case when normalized_orders.order_id is null then 1 else 0 end)
            as missing_after_normalization_count,
        sum(case when raw_feed.order_id is null then 1 else 0 end)
            as unexpected_after_normalization_count,
        sum(case when normalized_orders.order_status = 'unknown' then 1 else 0 end)
            as unknown_status_count
    from raw_feed
    full outer join normalized_orders on raw_feed.order_id = normalized_orders.order_id
{% endmacro %}

{% macro duckdb__render_platform_ingestion_reconciliation(raw_table_name, staged_model_name) %}
    {% set raw_relation = source('platform_app', raw_table_name) %}
    {% set staged_relation = ref(staged_model_name) %}

    with raw_feed as (
        select cast(order_id as varchar) as order_id
        from {{ raw_relation }}
    ),

    normalized_orders as (
        select
            order_id,
            order_status
        from {{ staged_relation }}
    )

    select
        count(raw_feed.order_id) as raw_order_count,
        count(normalized_orders.order_id) as normalized_order_count,
        count(*) filter (where normalized_orders.order_id is null)
            as missing_after_normalization_count,
        count(*) filter (where raw_feed.order_id is null)
            as unexpected_after_normalization_count,
        count(*) filter (where normalized_orders.order_status = 'unknown')
            as unknown_status_count
    from raw_feed
    full outer join normalized_orders on raw_feed.order_id = normalized_orders.order_id
{% endmacro %}
