# Project TODO

This backlog holds improvements that matter to the fixture but are intentionally
outside the current change. Items are grouped by outcome, not by file.

## Maintenance actions

See the [dependency review](docs/maintenance-review.md) for exact PR heads,
compatibility evidence, and validation limits.

- [ ] Close or replace incompatible dependency PRs #27 and #29 as part of a
  coordinated runtime upgrade; neither can install with the current pins.
- [ ] Complete the local validation gate for regex PR #28 before merging; clean
  installation and focused compatibility checks pass.
- [ ] Close obsolete setup-python PR #30; its workflow steps no longer exist.
- [ ] Recreate the drifted local fixture venv from the lock before the next full
  run, keeping unrelated tools in separate environments and preserving data.

## Documentation depth

- Deepen model-local `.md` files where grain, business meaning, caveats, or a
  useful example materially improves use. Reuse the existing `fct_orders` and
  `fct_order_revenue` examples instead of rewriting already sufficient docs.

## Live-data readiness

- Reintroduce source freshness only when the fixture has a live ingestion path,
  real ingestion timestamps, meaningful thresholds, and a deterministic job
  that acts on freshness results. Static synthetic seeds should not pretend to
  provide a live operational signal.

## Fixture depth

- Audit the public model surface and keep a model public only when a real
  downstream consumer, architectural claim, or tool-test case justifies the
  contract.
- Add focused dbt unit tests for important business behavior first. Existing
  legacy model versions and two staging relationship-test declarations provide
  examples; add more only for a named compatibility or integrity scenario.
- Add optional scale fixtures without making the default local workflow heavy.
- Maintain a small community-facing roadmap after the `v0.1.1` reference
  fixture baseline.

## Runtime evolution

- Upgrade the repository to dbt Core 1.12.
- During that upgrade, re-test MetricFlow's DuckDB quoting for the `order`
  entity. Prefer an upstream quoting fix over renaming the entity and breaking
  the existing semantic query interface.
- Add Python or JavaScript dbt functions only with an adapter/runtime path that
  can build and execute them end to end. Do not add parse-only function assets
  to the company estate merely to exercise artifact metadata.
