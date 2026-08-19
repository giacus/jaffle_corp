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
                'subject': 'orders'
            },
            {
                'feed_name': 'customers',
                'subject': 'customers'
            }
        ])
    }}
{% endmacro %}

{% macro platform_ingestion_relation_name(layer_prefix, subject) %}
    {{ return(layer_prefix ~ '_' ~ subject) }}
{% endmacro %}

{% macro platform_ingestion_volume_reconciliation() %}
    {% for feed in shared.platform_ingestion_feed_specs() %}
        {% if not loop.first %}
            union all
        {% endif %}

        {{
            shared.render_platform_ingestion_volume_reconciliation(
                feed.feed_name,
                shared.platform_ingestion_relation_name('raw', feed.subject),
                shared.platform_ingestion_relation_name('stg', feed.subject)
            )
        }}
    {% endfor %}
{% endmacro %}

{% macro render_platform_ingestion_volume_reconciliation(feed_name, raw_table_name, staged_model_name) %}
    {% set raw_relation = source('platform_app', raw_table_name) %}
    {% set staged_relation = ref(staged_model_name) %}

    select
        '{{ feed_name }}' as feed_name,
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
