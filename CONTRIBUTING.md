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
- Prefer narrow, understandable examples over broad rewrites.

## Local Validation

```bash
python3.11 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt

scripts/validate_repo.sh
```

The validation script installs dbt project dependencies, lints SQL project-by-project, invokes the sanitization guard, seeds local DuckDB sources, builds every project sequentially, and runs direct MetricFlow CLI queries. Run builds sequentially with the local DuckDB profile.

## Sanitization Check

Set `PROHIBITED_PATTERN` to any private-domain terms you want to block before publishing or merging:

```bash
PROHIBITED_PATTERN='private_term_one|private_term_two' scripts/check_sanitization.sh
```

The script ignores the command line that defines `PROHIBITED_PATTERN`, so copied examples do not self-match.
