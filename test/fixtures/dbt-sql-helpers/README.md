# Settlement SQL helpers and dispatch

The daily settlement report formats timestamps and hashes settlement identifiers
with dbt's official cross-database SQL helpers. Its string-type override records
the settlement policy dependency before returning a SQL type. The calendar uses
the official date-spine helper independently of the settlement models.

The graph has four models and two dependencies from `daily_settlement_keys`:
`settlement_events` and `settlement_type_policy`. SQL-only helper bodies do not
introduce graph resources. A graph implementation must still follow the
project's dispatch override and eagerly evaluate helper arguments; treating all
`dbt.*` helpers as dependency-free would miss the policy edge.

Copy the fixture to an isolated temporary directory and copy
`profiles.example.yml` to `profiles.yml`. Run `dbt parse --project-dir .
--profiles-dir . --no-partial-parse --write-json`. The fixture also contains
executable DuckDB model SQL; warehouse execution is not needed for graph parity.
It works with both Core and native dbt. The official helper sources are in
[dbt-adapters' global project](https://github.com/dbt-labs/dbt-adapters/tree/f353ce0c30820b7aa363b6a7b39d5ef3b4e910d9/dbt-adapters/src/dbt/include/global_project/macros/utils).
