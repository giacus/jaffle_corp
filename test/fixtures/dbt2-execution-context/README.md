# Execution context fixture

This small dbt 2 project models an order dashboard with a development input and
a production input. Its selected dependency and tag come from `target.name`.
The `jaffle_context` profile defaults to development; `alternate_context`
defaults to production. Both use an in-memory DuckDB connection.

Run native commands from an isolated copy. Compare ordinary profile selection,
`DBT_TARGET`, `DBT_PROFILE`, explicit overrides, and profiles-file precedence.
Each successful parse should contain three models and exactly one dashboard
dependency. A missing or invalid selected profile must not silently fall back
to another available profile or directory.

No warehouse access is needed for `dbt parse` or `dbt list`.
