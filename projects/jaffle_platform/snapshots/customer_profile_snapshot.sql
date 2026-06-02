{% snapshot customer_profile_snapshot %}
    {{
        config(
            target_schema=target.schema ~ '_snapshots',
            unique_key='customer_id',
            strategy='timestamp',
            updated_at='updated_at_utc'
        )
    }}

    select
        customer_id,
        customer_name,
        email_domain,
        loyalty_region,
        first_seen_at,
        default_currency,
        marketing_consent,
        updated_at_utc
    from {{ ref('stg_customers') }}

{% endsnapshot %}
