# Settlement report interpreter fixture

This native dbt 2 fixture describes reports over settlement events and their
adjustments. Its nine models and ten dependency edges exercise nested namespace
values, keyword dictionaries, a mutable copy of varargs, caller blocks, exact
wide JSON integers, source-known relation transformations, and a filtered
settlement reconciliation. The reconciliation macro splits its channel list,
iterates over `(channel, model)` tuples with a filter, and references only the
selected capture and adjustment models. The policy model is available but stays
out of the graph because its tuple is filtered out. The report sums integer
cent tolerances for those selected channels and uses a SQL-inline formatting
macro to classify the adjustment.
The original event relation in `relation_report` remains a dependency because
its `ref` call executes before the transformed identifier is referenced.

Copy this directory to a temporary location and copy `profiles.example.yml`
to `profiles.yml` there. Run `dbt parse --project-dir . --profiles-dir .
--no-partial-parse --write-json`. No credentials or warehouse tables are needed
for parsing. This fixture targets native 2 semantics, including mutable
varargs slices, and does not claim that those expressions have Core behavior.

The daglane source graph should preserve every model, all ten edges and the
settlement tag without SQL compilation or manifest input. The reconciliation
model adds exactly two edges: it depends on `settlement_events` and
`settlement_adjustments`, but not `settlement_type_policy`. The independent
native manifest supplies the reference result.
