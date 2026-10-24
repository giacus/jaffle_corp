# Settlement report interpreter fixture

This native dbt 2 fixture describes reports over settlement events and their
adjustments. Its eight models and eight dependency edges exercise nested
namespace values, keyword dictionaries, a mutable copy of varargs, caller
blocks, exact wide JSON integers and source-known relation transformations.
The original event relation in `relation_report` remains a dependency because
its `ref` call executes before the transformed identifier is referenced.

Copy this directory to a temporary location and copy `profiles.example.yml`
to `profiles.yml` there. Run `dbt parse --project-dir . --profiles-dir .
--no-partial-parse --write-json`. No credentials or warehouse tables are needed
for parsing. This fixture targets native 2 semantics, including mutable
varargs slices, and does not claim that those expressions have Core behavior.

The daglane source graph should preserve every model, all eight edges and the
settlement tag without SQL compilation or manifest input. The independent
native manifest supplies the reference result.
