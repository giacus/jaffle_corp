{{ config(materialized='table' if jaffle_source_context.audit_prefers_full_rebuild() else 'incremental') }}

select * from {{ ref('stg_orders') }}
