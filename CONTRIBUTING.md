# Contributing

Thanks for helping make `jaffle-corp` a useful public dbt reference fixture.

The goal is realistic, inspectable complexity rather than maximum complexity.
Contributions should improve at least one supported use: architecture
exploration, analytics-tool testing, public-contract validation, downstream
extension work, or the optional guided labs.

## Good Contributions

- Add realistic fictional jaffle-shop scenarios.
- Improve local run instructions or dbt compatibility.
- Add focused tests for public interfaces.
- Add examples of common modeling tradeoffs.
- Improve Semantic Layer or MetricFlow examples.
- Improve migration examples in `projects/legacy`.

## Boundaries

- Do not add real company data, internal system names, real schemas, warehouse names, customer names, personal emails, or private business entities.
- Keep seed data small and synthetic.
- Avoid copying SQL from private repositories.
- Avoid copying source files, generated data, screenshots, images, or docs from upstream Jaffle Shop repositories unless the license or permission is clear and attribution is preserved.
- Do not use dbt Labs logos, trademarks, screenshots, or branding as if this project were official or endorsed.
- Prefer narrow, understandable examples over broad rewrites.

## Attribution

This project is inspired by dbt Labs' [`jaffle-shop`](https://github.com/dbt-labs/jaffle-shop), but it is independently authored and not affiliated with dbt Labs. See [ATTRIBUTION.md](ATTRIBUTION.md) before adding material based on upstream Jaffle Shop examples.

## Local Validation

```bash
scripts/validate_local.sh
```

The validator is a clean rebuild: it removes generated dbt artifacts and the
default local DuckDB database before checking the fixture, while preserving
tracked source files and `.venv`. Preview or remove all end-of-session state
with `scripts/clean.sh --dry-run` or `scripts/clean.sh`.

The bootstrap script creates or reuses a Python 3.11 `.venv`, installs pinned
dependencies and the activation hook, resolves dbt packages where needed, and
verifies that `dbt compile` can find the repo-local profile for
`platform`. Use
`scripts/bootstrap.sh --full` to compile every runnable dbt project
and generate the full manifest during setup. The validation script installs dbt
project dependencies, lints SQL project-by-project, seeds local DuckDB sources,
builds shared and platform once and then each owning package sequentially, and
runs direct MetricFlow CLI queries. Run builds sequentially with the local
DuckDB profile. It finishes by regenerating the complete git-ignored
`target/manifest.json`; use
`scripts/generate_manifest.sh` when you only need that artifact.

The complete pre-push gate is `scripts/validate_local.sh`. It bootstraps the
pinned environment, checks Markdown, YAML, Semantic Layer bindings and repository
policy, runs Python tests and shell/Python syntax checks, then executes the full
dbt/MetricFlow validator and generates documentation.

Before an agent starts validation expected to exceed five minutes, it must warn
the owner and receive explicit consent. When the executable fixture surface is
unchanged, still-valid prior evidence may be reused; record its source and state
which long gate was not rerun. Never report reused evidence as a fresh pass.

GitHub Actions runs only through `workflow_dispatch`. Its optional manual job
checks trigger policy; it does not validate the fixture. There is no automatic
pull-request, push, or weekly validation run.

## Safe Change Process

Use pull requests for all changes that should land on the default branch.

1. Create a branch from `master`.
2. Make the smallest coherent change.
3. Run `scripts/validate_local.sh` before pushing, subject to the long-run
   consent and evidence-reuse rules above. Record exact commands and outcomes.
4. Open a draft pull request and fill out the human safety checks.
5. Review public contract changes with
   `python scripts/report_public_contract_changes.py origin/master`.
6. Merge only after reviewing local validation evidence and the change itself.
   The optional remote policy job is not a merge gate.

The default branch is `master`. Recommended protection requires pull requests
and blocks direct pushes, force pushes, and branch deletion, including for
administrators outside an explicit emergency-maintenance reason. Do not require
the removed automatic `validate` check. If the default branch is renamed, apply
the same protections to the new name.
