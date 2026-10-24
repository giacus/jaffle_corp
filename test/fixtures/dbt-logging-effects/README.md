# Logging during settlement graph discovery

The report logs its settlement input, then selects the positive settlements.
The graph has three models and two direct dependencies from `settlement_report`:
one on `settlement_events` evaluated eagerly inside `log()`, and one on
`positive_settlement_events` selected using the logging call's empty result.
`print()` and `log()` both return empty strings in Core and native dbt. Logging
text does not become model SQL or an extra resource.

This fixture intentionally emits operational stdout even with quiet mode.
Native comparison should read a fresh manifest artifact and retain the command
output; a JSON-lines-only reader cannot assume every stdout line is a resource.

Copy this directory into an isolated temporary workspace, copy
`profiles.example.yml` to `profiles.yml`, and run `dbt parse --project-dir .
--profiles-dir . --no-partial-parse --write-json`. No warehouse command is
needed to observe these dependencies. The fixture declares a shared Core/native
range because these logging semantics do not require family routing.

Primary source references are native dbt 2.0.8
[`print_fn` and `log_fn`](https://github.com/dbt-labs/dbt/blob/43918198c2f02366ceb33f60006812872b0bab40/crates/dbt-jinja-utils/src/functions/base.rs#L928-L1019)
and Core 1.11.12
[`log`](https://github.com/dbt-labs/dbt-core/blob/v1.11.12/core/dbt/context/base.py#L523-L550)
and [`print`](https://github.com/dbt-labs/dbt-core/blob/v1.11.12/core/dbt/context/base.py#L630-L644).
The native executable's exact version/hash is recorded separately by the
daglane comparison harness; the public source pin is not its binary provenance.
