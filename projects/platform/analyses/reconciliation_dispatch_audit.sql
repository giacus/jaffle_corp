-- Inspect the reconciliation input selected for this adapter and dbt target.
select * from {{ reconciliation_input() }}
