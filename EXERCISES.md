# Exercise Catalog

The structured course and the exercise catalog now use the same task files.
Follow them in order from [docs/course_path.md](docs/course_path.md), or choose a
single task below by skill and difficulty.

## Guided

- [Get the project running](docs/course/01-get-running.md): setup, platform, and repo landmarks.
- [Trace recognized revenue](docs/course/02-trace-revenue.md): lineage, selection, tests, and ownership.
- [Navigate the full manifest](docs/course/03-navigate-manifest.md): artifacts, access, contracts, and graph links.
- [Prove a test can fail](docs/course/04-prove-test-failure.md): controlled fixture failure and recovery.

## Intermediate

- [Protect a price-window invariant](docs/course/05-add-behavior-test.md): interval logic and singular tests.
- [Review a contract change](docs/course/06-review-contract-change.md): compatibility and blast-radius analysis.
- [Observe snapshot history](docs/course/07-observe-snapshot-history.md): timestamp snapshots and SCD history.
- [Query the semantic layer](docs/course/08-query-semantic-layer.md): measures, metrics, dimensions, and MetricFlow.

## Advanced

- [Refactor a legacy interface](docs/course/09-refactor-legacy-interface.md): characterization and compatibility.
- [Build a cross-domain capstone](docs/course/10-cross-domain-capstone.md): grain, dependencies, contracts, and tests.

## Stretch Ideas

- Add a variable-controlled threshold and prove both branches.
- Extract a repeated business expression into `jaffle_shared` with tests that
  justify the abstraction.
- Add MetricFlow coverage for substitution readiness or planning exceptions.
- Add a saved query only after naming a repeated consumer.
- Explore a dbt unit test, an incremental model with a full-refresh comparison,
  or a state-based selection workflow.

These tasks provide expected observations, not an answer key. A green command is
only part of completion; explain grain, ownership, and validation choices too.
