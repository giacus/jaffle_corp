# Contributing

Thanks for helping make `jaffle-corp` a useful public dbt playground.

The goal is realistic complexity, not maximum complexity. Contributions should make it easier for people to learn how dbt projects behave once they include multiple domains, project dependencies, contracts, semantic models, legacy marts, and imperfect source data.

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
scripts/bootstrap.sh
source .venv/bin/activate
scripts/validate_repo.sh
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
builds every project sequentially, and runs direct MetricFlow CLI queries. Run
builds sequentially with the local DuckDB profile. It finishes by regenerating
the complete git-ignored `target/manifest.json`; use
`scripts/generate_manifest.sh` when you only need that artifact.

## Safe Change Process

Use pull requests for all changes that should land on the default branch.

1. Create a branch from `master`.
2. Make the smallest coherent change.
3. Run `scripts/validate_repo.sh` locally.
4. Open a pull request and fill out the checklist.
5. Wait for the `validate` GitHub Actions check to pass.
6. Merge only after CI is green and the PR has had a reasonable review.

The default branch is `master`. It should be protected in GitHub settings so
direct pushes, force pushes, deletions, and merges with failing CI are blocked.
If the repository is renamed to use `main`, apply the same protection to `main`.

Recommended branch protection for the default branch:

- Require a pull request before merging.
- Require the `validate` status check to pass.
- Require branches to be up to date before merging.
- Block force pushes and branch deletion.
- Include administrators unless there is an explicit emergency-maintenance
  reason not to.
