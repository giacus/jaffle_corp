{{ config(materialized='table') }}

with recursive dates as (
    select cast('2026-01-01' as date) as date_day

    union all

    select date_day + interval 1 day
    from dates
    where date_day < cast('2026-12-31' as date)
)

select date_day
from dates
