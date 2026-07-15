# Jaffle Catalog

`jaffle_catalog` is a tooling project, not a business domain. It imports every
local dbt project so dbt can parse their resources into one canonical artifact:

```text
target/manifest.json
```

Generate it from the repository root:

```bash
scripts/generate_manifest.sh
```

Do not add business models here. Add them to the domain that owns the data and
business meaning. If you create another project under `projects/`, add it to
`packages.yml` so the full-project manifest continues to include it.

This catalog compiles the complete graph but does not build relations. Use
`scripts/validate_repo.sh` when you need seeds, models, tests, SQL linting, and
MetricFlow queries as well as the regenerated manifest.
