{{ config(enabled=false, materialized='view', tags=['policy_inline'], pre_hook='select 3') }}
select 1 as settlement_event_id, 101 as customer_id, 24.50 as settled_amount
