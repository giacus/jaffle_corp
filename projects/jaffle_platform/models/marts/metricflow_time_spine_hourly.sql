{{ config(materialized='table') }}

with recursive hours as (
    select cast('2026-01-01 00:00:00' as timestamp) as date_hour

    union all

    select date_hour + interval 1 hour
    from hours
    where date_hour < cast('2026-01-14 23:00:00' as timestamp)
)

select date_hour
from hours
