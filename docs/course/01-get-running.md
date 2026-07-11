# Task 1: Get the Project Running

[Course path](../course_path.md) · Next: [Trace recognized revenue](02-trace-revenue.md)

## At a Glance

- **Level:** guided
- **Time:** 20–30 minutes
- **Requires:** a fresh clone, Python 3.11 or 3.12, and a terminal
- **You will:** build one project and learn the repo's main landmarks.

## Start Here

From the repository root:

```bash
scripts/bootstrap.sh
source .venv/bin/activate
dbt debug --project-dir projects/jaffle_platform
dbt deps --project-dir projects/jaffle_platform
dbt seed --project-dir projects/jaffle_platform
dbt build --project-dir projects/jaffle_platform --exclude resource_type:seed
```

The seed runs separately because staging models read raw tables with `source()`;
dbt cannot infer that those source tables come from local seeds.

## Take the Tour

Open these in order:

1. `profiles.yml` — the shared DuckDB connection.
2. `projects/jaffle_platform/dbt_project.yml` — project configuration.
3. `projects/jaffle_platform/seeds` — synthetic raw data.
4. `projects/jaffle_platform/models/staging` — source cleanup.
5. `projects/jaffle_platform/models/marts` — stable interfaces.

Then list the public platform models:

```bash
dbt ls --project-dir projects/jaffle_platform \
  --select access:public \
  --resource-type model
```

## Checkpoint

You are done when you can explain:

- where the local database and profile live;
- why seeds run before source-backed models;
- how raw input becomes a public platform model;
- how to rebuild platform from the repository root.

Continue to [Task 2: Trace recognized revenue](02-trace-revenue.md).
