-- The migration job remains pinned to the stable v1 contract while teams
-- inspect the current interface separately in legacy_surface_inventory.
-- Declaring the stable relation here ensures it is prepared before this
-- run-time availability check is evaluated.
-- depends_on: {{ stable_customer_migration_relation() }}

{% if execute %}
    {% set configured_relation = stable_customer_migration_relation() %}
    {% set available_relation = load_relation(configured_relation) %}

    {% if available_relation is not none %}
        select
            '{{ configured_relation }}' as configured_relation,
            true as is_available,
            count(*) as customer_count,
            max(last_business_dt) as latest_business_date
        from {{ available_relation }}
    {% else %}
        select
            '{{ configured_relation }}' as configured_relation,
            false as is_available,
            cast(null as bigint) as customer_count,
            cast(null as date) as latest_business_date
    {% endif %}
{% else %}
    select
        cast(null as varchar) as configured_relation,
        false as is_available,
        cast(null as bigint) as customer_count,
        cast(null as date) as latest_business_date
{% endif %}
