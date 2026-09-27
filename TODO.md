# Project TODO

This backlog holds improvements that matter to the fixture but are intentionally
outside the current change. Items are grouped by outcome, not by file.

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
- Extend focused dbt unit tests to other important business rules; Finance
  margin-waterfall tests now cover item aggregation, variance signs, and missing
  recipe costs. Existing legacy versions and staging relationship tests provide
  compatibility and integrity examples.
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
