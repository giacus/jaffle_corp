# Project TODO

This backlog holds improvements that matter to the fixture but are intentionally
outside the current change. Items are grouped by outcome, not by file.

## Documentation depth

- Deepen model-local `.md` files with grain, business meaning, caveats, and a
  useful example where it materially improves inspection or use.

## Live-data readiness

- Reintroduce source freshness only when the fixture has a live ingestion path,
  real ingestion timestamps, meaningful thresholds, and a deterministic job
  that acts on freshness results. Static synthetic seeds should not pretend to
  provide a live operational signal.

## Fixture depth

- Add an automated architecture-policy check for public-only cross-project refs
  and the deliberate `shared` package exception.
- Audit the public model surface and keep a model public only when a real
  downstream consumer, architectural claim, or tool-test case justifies the
  contract.
- Add focused model versions, dbt unit tests, and relationship tests where they
  demonstrate compatibility or protect important business behavior.
- Add optional scale fixtures without making the default local workflow heavy.
- Maintain a small community-facing roadmap after the `v0.1.1` reference
  fixture baseline.

## Runtime evolution

- Upgrade the repository to dbt Core 1.12 only when the supported local
  Semantic Layer toolchain can move with it. Keep one dbt runtime and one lock;
  evaluate OSI, semantic YAML v2, UDF overloads, and new file-discovery behavior
  as part of that whole-repository upgrade rather than a parallel fixture lane.
- Add Python or JavaScript dbt functions only with an adapter/runtime path that
  can build and execute them end to end. Do not add parse-only function assets
  to the company estate merely to exercise artifact metadata.
