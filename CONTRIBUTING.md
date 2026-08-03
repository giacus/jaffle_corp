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
builds shared and platform once and then each owning package sequentially, and
runs direct MetricFlow CLI queries. Run builds sequentially with the local
DuckDB profile. It finishes by regenerating the complete git-ignored
`target/manifest.json`; use
`scripts/generate_manifest.sh` when you only need that artifact.

The required pull-request check is authoritative and starts from a clean
runner. It always validates Markdown, YAML, Semantic Layer bindings, repository
policy, public-contract changes, and its own routing/gate logic. The complete
dbt and MetricFlow validator runs only for executable fixture and CI changes.
Changes to `scripts/docs.sh` additionally execute docs generation. A weekly run
keeps the pinned environment honest without repeating the full suite after each
merge to protected `master`.

## Safe Change Process

Use pull requests for all changes that should land on the default branch.

1. Create a branch from `master`.
2. Make the smallest coherent change.
3. Run the smallest relevant local check; use `scripts/validate_repo.sh` when a
   dbt or Semantic Layer change needs a clean preflight.
4. Open a pull request and fill out the human safety checks.
5. Review CI's public-contract report and wait for `validate` to pass.
6. Merge only after CI is green and the change has had a reasonable review.

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
