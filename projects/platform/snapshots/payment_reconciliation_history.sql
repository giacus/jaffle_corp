{% snapshot order_reconciliation_history %}
    {{ config(target_schema=target.schema ~ '_snapshots', unique_key='order_id',
              strategy='check', check_cols='all') }}
    select * from {{ ref('stg_orders') }}
{% endsnapshot %}

{% snapshot payment_reconciliation_history %}
    {{ config(target_schema=target.schema ~ '_snapshots', unique_key='payment_id',
              strategy='check', check_cols='all') }}
    select * from {{ ref('stg_payments') }}
{% endsnapshot %}
