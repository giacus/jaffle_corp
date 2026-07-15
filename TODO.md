# Project TODO

This backlog holds improvements that matter to the fixture but are intentionally
outside the current change. Items are grouped by outcome, not by file.

## Documentation depth

- Deepen model-local `.md` files with grain, business meaning, caveats, and a
  useful example where it helps a learner.

## Live-data readiness

- Reintroduce source freshness only when the fixture has a live ingestion path,
  real ingestion timestamps, meaningful thresholds, and a deterministic job
  that acts on freshness results. Static synthetic seeds should not pretend to
  provide a live operational signal.

## Fixture depth

- Add an automated architecture-policy check for public-only cross-project refs
  and the deliberate `shared` package exception.
- Audit the public model surface and keep a model public only when a real
  downstream consumer or learning objective justifies the contract.
- Add focused model versions, dbt unit tests, and relationship tests where they
  teach compatibility or protect important business behavior.
- Document the synthetic-data edge-case matrix and add optional scale fixtures
  without making the default local workflow heavy.
- Publish a first release and maintain a small community-facing roadmap.
