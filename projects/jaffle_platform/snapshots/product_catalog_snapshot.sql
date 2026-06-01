{% snapshot product_catalog_snapshot %}
    {{
        config(
            target_schema=target.schema ~ '_snapshots',
            unique_key='product_id',
            strategy='timestamp',
            updated_at='updated_at_utc'
        )
    }}

    select
        product_id,
        sku,
        product_name,
        category,
        product_family,
        list_price_minor,
        catalog_currency,
        is_limited_time,
        updated_at_utc
    from {{ ref('stg_products') }}

{% endsnapshot %}

