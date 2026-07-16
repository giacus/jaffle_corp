# Lab 1: Get the Project Running

[Labs](../labs.md) · Next: [Trace recognized revenue](02-trace-revenue.md)

## At a Glance

- **Level:** guided
- **Time:** 20–30 minutes
- **Requires:** a fresh clone, Python 3.11, and a Bash-compatible terminal
- **You will:** build one project and learn the repo's main landmarks.

## Start Here

If you already completed the README five-minute start, skip this command block
and resume at **Take the Tour**.

From the repository root:

```bash
scripts/bootstrap.sh
source .venv/bin/activate
dbt debug --project-dir projects/platform
dbt deps --project-dir projects/platform
dbt seed --project-dir projects/platform
dbt build --project-dir projects/platform --exclude resource_type:seed
```

The seed runs separately because staging models read raw tables with `source()`;
dbt cannot infer that those source tables come from local seeds.

## Take the Tour

Open these in order:

1. `profiles.yml` — the shared DuckDB connection.
2. `projects/shared/dbt_project.yml` — centralized staging configuration.
3. `projects/shared/seeds/platform` — synthetic core raw data.
4. `projects/shared/models/staging/platform` — core source cleanup.
5. `projects/platform/dbt_project.yml` — platform project configuration.
6. `projects/platform/models/marts` — stable interfaces.

Then list the public platform models:

```bash
dbt ls --project-dir projects/platform \
  --select access:public \
  --resource-type model
```

## See the Result

End the setup loop with a human-readable result, not only successful logs:

```bash
dbt show --project-dir projects/platform --inline \
  "select order_id, ordered_date_utc, order_status, currency, order_total_major, order_total_usd from {{ ref('fct_orders') }} order by ordered_at_utc" \
  --limit 5
```

Read across the result and identify the order key, business identifier, status,
currency, and monetary fields. Then compare the displayed columns with the
contract in `projects/platform/models/marts/fct_orders/fct_orders.yml`.

## Expected Observations

- `dbt debug` confirms that the shared DuckDB profile is usable.
- The build creates a contracted public order fact after loading synthetic raw
  tables.
- `dbt show` returns one readable row per order and makes the contract concrete.
- Public models are only one layer of the graph; staging and intermediate models
  remain implementation details.

## Common Failure Modes

If dbt reports that a raw source table does not exist, the seed step was skipped
or ran against a different profile. If it cannot find a package, rerun
`scripts/bootstrap.sh` and reactivate `.venv` before retrying the dbt command.

## Workspace State and Cleanup

This lab creates `.venv`, downloaded dbt packages, logs, compiled artifacts, and
relations in the local DuckDB database. All are generated local state; none
should be committed. Keep them for the next labs, or run
`scripts/clean.sh` when you finish the session. For an intentional restart, use
`scripts/clean.sh --keep-venv`, then rerun this lab before continuing.

## Completion Rubric

- [ ] The platform build and `dbt show` command both succeed.
- [ ] You can point to the local database, profile, raw seeds, staging models,
      and public marts.
- [ ] You can explain why seeds run before source-backed models.
- [ ] You can describe how a raw order becomes one row in `fct_orders` without
      reading every SQL file.

Continue to [Lab 2: Trace recognized revenue](02-trace-revenue.md).
