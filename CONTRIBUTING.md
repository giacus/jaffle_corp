# Contributing

Thanks for helping make `jaffle-corp` a useful public dbt playground.

The goal is realistic complexity, not maximum complexity. Contributions should make it easier for people to learn how dbt projects behave once they include multiple domains, project dependencies, contracts, semantic models, legacy marts, and imperfect source data.

## Good Contributions

- Add realistic fictional jaffle-shop scenarios.
- Improve local run instructions or dbt compatibility.
- Add focused tests for public interfaces.
- Add examples of common modeling tradeoffs.
- Improve Semantic Layer or MetricFlow examples.
- Improve migration examples in `projects/jaffle_legacy`.

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
python3.11 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt

scripts/validate_repo.sh
```

The validation script installs dbt project dependencies, lints SQL project-by-project, seeds local DuckDB sources, builds every project sequentially, and runs direct MetricFlow CLI queries. Run builds sequentially with the local DuckDB profile.
