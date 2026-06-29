# Extension Authoring

Use this guide when you want to build a downstream dbt project that relies on
`jaffle-corp` instead of editing the core domains directly.

The reference implementation is `projects/jaffle_reliability`. It consumes
public contracted marts from finance, merchandising, and planning, then adds its
own model, contract, tests, and analysis.

## Rules

- Depend on public models only.
- Treat protected staging and intermediate models as implementation details.
- Define the downstream model grain before choosing upstream refs.
- Add a model contract for every extension mart that should be reused.
- Keep extension-specific logic in the extension project.
- Run the upstream stack before iterating on an extension model in local dbt
  Core.

## Local dbt Core Pattern

Inside this monorepo, keep extension fixtures under `projects/` so local package
paths resolve as siblings:

```text
projects/jaffle_reliability
```

The extension should include:

- `dbt_project.yml` for its own schemas, tags, and default materialization.
- `packages.yml` with local package fallbacks for the upstream projects it
  consumes.
- `dependencies.yml` with the intended dbt Mesh project dependencies.
- `models/marts/<model>/<model>.yml` with public access and enforced contracts
  for reusable extension marts.
- `models/marts/<model>/<model>.md` with model-local docs blocks.
- Singular tests for behavior that generic tests cannot express.
- Analyses that demonstrate useful exploratory queries without becoming
  production marts.

Build from the repo root:

```bash
scripts/validate_repo.sh
```

Iterate on only the extension after upstream projects have been built:

```bash
cd projects/jaffle_reliability
dbt deps
dbt build --select jaffle_reliability
cd ../..
```

## Public Interfaces To Start From

Good first upstream refs for extension projects:

- `ref('jaffle_finance', 'fct_store_day_revenue_quality')`
- `ref('jaffle_merchandising', 'fct_product_store_day_availability')`
- `ref('jaffle_merchandising', 'fct_substitution_readiness')`
- `ref('jaffle_planning', 'fct_store_day_capacity_plan')`
- `ref('jaffle_planning', 'fct_planning_exception_daily')`

Before adding a new upstream dependency, inspect the model YAML and confirm:

- `access: public`
- `contract.enforced: true`
- the grain is documented by key columns and tests
- the needed column names and data types are part of the contract

## Review Checklist

- Does the extension avoid refs to `staging` and `intermediate` models?
- Does every new mart have a stable key and a declared grain?
- Would changing an upstream contracted column break this extension loudly?
- Is there at least one test that protects the extension's business logic?
- Can a student understand the model from lineage, YAML, and one analysis query?
