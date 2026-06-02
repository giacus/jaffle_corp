# Publication Checklist

Use this before publishing `jaffle-corp` as an open-source repository.

## Required

- Confirm the repository name is `jaffle-corp`.
- Confirm every seed row is synthetic.
- Run the sanitization script with private-domain terms.
- Run dbt parse or build for each project in dependency order.
- Seed source-owning projects before local DuckDB builds: platform, supply, experience, store ops, merchandising, and planning.
- Confirm ignored artifacts are not committed: `.venv`, `target`, `dbt_packages`, `logs`, and `*.duckdb`.
- Confirm README quickstart works from a fresh clone.
- Confirm [../ATTRIBUTION.md](../ATTRIBUTION.md) accurately describes the relationship to dbt Labs' Jaffle Shop project.
- Confirm no upstream Jaffle Shop source files, generated data, screenshots, images, or docs have been copied without a checked license or permission and preserved attribution.
- Confirm the repository does not imply dbt Labs affiliation, endorsement, or official status.
- Decide which merchandising and planning marts should become public contracts.
- Review [../TODO.md](../TODO.md) and keep the list deliberately incomplete for student exercises.

## Recommended

- Add repository description: "A realistic multi-project dbt demo inspired by Jaffle Shop."
- Add topics: `dbt`, `analytics-engineering`, `semantic-layer`, `metricflow`, `duckdb`, `jaffle-shop`.
- Enable GitHub Actions on pull requests.
- Enable Dependabot or a periodic dependency review.
- Add a first release tag after the initial public build passes.

## Maintainer Notes

This repo should stay fictional. The complexity should come from dbt architecture and analytics-engineering patterns, not from traceable real-world domains.

Keep the repository standalone rather than turning it into a GitHub fork unless the project strategy changes to maintaining a direct derivative of `dbt-labs/jaffle-shop`.
