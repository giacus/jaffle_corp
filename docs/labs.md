# Labs

This is the guided lab route through `jaffle-corp`. Work from top to bottom when
you want a coherent sequence, or open one lab directly when you already have its
prerequisites.

Every lab lives in its own file and follows the same teaching contract: purpose,
setup, work, expected observations, common failure modes, workspace state and cleanup,
completion evidence, and next step.

## Choose a Route

- **Quick tour:** labs 1–3, about 90 minutes.
- **Half-day workshop:** labs 1–6.
- **Full lab sequence:** all ten labs, ending with the capstone.
- **Pick one skill:** choose a lab by level from the journey below.

## Start Once

From the repository root:

```bash
scripts/bootstrap.sh
source .venv/bin/activate
```

Stay at the repository root unless a lab explicitly changes directories. Run
dbt commands sequentially because all projects share one local DuckDB file.
If you already completed the README start, Lab 1 tells you where to resume
without repeating setup. For labs that change tracked files, use a disposable
learning branch. Keep generated state while following the sequence: later labs
reuse earlier seeds and builds. Use `scripts/clean.sh --keep-venv` only for an
intentional restart, then rerun Lab 1 and the stated prerequisites.
`scripts/clean.sh` removes everything generated when the session ends.

## The Journey

| # | Lab | Level | Time | Outcome |
| --- | --- | --- | --- | --- |
| 1 | [Get the project running](labs/01-get-running.md) | Guided | 20–30 min | Build platform and learn the repo landmarks. |
| 2 | [Trace recognized revenue](labs/02-trace-revenue.md) | Guided | 25–35 min | Follow lineage across project boundaries. |
| 3 | [Navigate the full manifest](labs/03-navigate-manifest.md) | Guided | 20–30 min | Find ownership, contracts, and dependencies from one artifact. |
| 4 | [Prove a test can fail](labs/04-prove-test-failure.md) | Guided | 20–30 min | Break and restore a controlled fixture. |
| 5 | [Protect a price-window invariant](labs/05-add-behavior-test.md) | Intermediate | 45–60 min | Write a singular test for real business behavior. |
| 6 | [Review a contract change](labs/06-review-contract-change.md) | Intermediate | 30–45 min | Assess compatibility before editing code. |
| 7 | [Observe snapshot history](labs/07-observe-snapshot-history.md) | Intermediate | 30–45 min | See how an SCD snapshot records change. |
| 8 | [Query the semantic layer](labs/08-query-semantic-layer.md) | Intermediate | 30–45 min | Trace a metric into a MetricFlow result. |
| 9 | [Refactor a legacy interface](labs/09-refactor-legacy-interface.md) | Advanced | 60–90 min | Improve debt while preserving behavior. |
| 10 | [Build a cross-domain capstone](labs/10-cross-domain-capstone.md) | Advanced | 2–4 hr | Design, contract, and test a new downstream use case. |

## Mental Model

Use this map when a lab introduces an unfamiliar surface:

| Concept | Where to look |
| --- | --- |
| Local profile | `profiles.yml` |
| Project boundaries | `projects/*/dbt_project.yml` |
| Code packages and local dbt Core fallbacks | `projects/*/packages.yml` |
| Public domain-project dependencies | `projects/*/dependencies.yml` |
| Domain ownership | `docs/architecture.md` |
| Company flow and fixture edge cases | `docs/company-and-fixtures.md` |
| Staging models | `projects/shared/models/staging/<domain>` |
| Intermediate models | `projects/*/models/intermediate` |
| Public marts and contracts | `projects/*/models/marts/<model>/<model>.yml` |
| Singular tests | `projects/*/tests` |
| Snapshots | `projects/platform/snapshots` |
| Semantic models and metrics | `projects/*/models/semantic_models.yml` and `projects/*/models/metrics.yml` |
| Downstream extension pattern | `projects/reliability` |
| Full-project artifact | `target/manifest.json` from `scripts/generate_manifest.sh` |
| End-to-end validation | `scripts/validate_repo.sh` |

Start with [Lab 1: Get the project running](labs/01-get-running.md).

## Stretch Ideas

After the guided labs, extend the fixture without adding complexity for its
own sake:

- Add a variable-controlled threshold and prove both branches.
- Extract a repeated business expression into `jaffle_shared` with tests that
  justify the abstraction.
- Add MetricFlow coverage for substitution readiness or planning exceptions.
- Add a saved query only after naming a repeated consumer.
- Explore a dbt unit test, an incremental model with a full-refresh comparison,
  or a state-based selection workflow.

Expected observations are guardrails, not an answer key. A green command is only
part of completion; each lab also asks for evidence about grain, ownership,
business behavior, or validation choices.
