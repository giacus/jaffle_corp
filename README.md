# jaffle-corp

[![CI](https://github.com/giacus/jaffle_corp/actions/workflows/ci.yml/badge.svg)](https://github.com/giacus/jaffle_corp/actions/workflows/ci.yml)

`jaffle-corp` is a laptop-runnable, multi-project dbt Core reference fixture for
exploring and testing domain boundaries, public model contracts, cross-project
dependencies, Semantic Layer behavior, downstream extensions, and legacy
migrations.

The company is fictional, the data is synthetic, and the default stack is dbt
Core plus DuckDB. No warehouse credentials or dbt Cloud account are required.
Every dbt project requires the tested dbt Core 1.11.12 release, and bootstrap
installs the exact transitive Python versions in `requirements.lock.txt`.

`jaffle-corp` is the human-facing fixture name, `jaffle_corp` is the repository
and dbt profile identifier, and `shared`, `platform`, `finance`, and the other
short names are dbt project identities.

> [!NOTE]
> This fixture assumes familiarity with `ref`, sources, and generic tests. It is
> intended for analytics engineers, dbt maintainers, tool authors, extension
> authors, and advanced practitioners who need a realistic but inspectable dbt
> estate. If the dbt foundations are new, start with the official
> [dbt quickstart](https://docs.getdbt.com/) and return afterward.

## Five-Minute Start

The tested local path is Python 3.11 on macOS or Linux with Bash or Zsh. Windows
users should use WSL. The first setup needs internet access and approximately
1 GiB of free disk space, including room for downloads and generated state.

Clone the current repository and enter it:

```bash
git clone https://github.com/giacus/jaffle_corp.git
cd jaffle_corp
scripts/bootstrap.sh
source .venv/bin/activate
dbt seed --project-dir projects/platform
dbt build --project-dir projects/platform --exclude resource_type:seed
dbt show --project-dir projects/platform --select fct_orders --limit 5
scripts/generate_manifest.sh
```

The `dbt show` result is the first payoff: a readable preview of the public
order fact you just built. You also have a complete, git-ignored project index
at `target/manifest.json`. For installation choices, environment behavior,
cleanup, and troubleshooting, read [Getting Started](docs/getting-started.md).

## How the Repo Is Organized

Folder and dbt project names deliberately use the same short domain identifier.
Those identifiers also appear in artifacts, selectors, package namespaces, and
two-argument `ref()` calls, so the graph stays readable end to end.

| Folder | dbt project | Responsibility |
| --- | --- | --- |
| `shared` | `shared` | Synthetic seeds, sources, staging models, macros, and schema behavior. |
| `platform` | `platform` | Conformed dimensions and stable core interfaces. |
| `supply` | `supply` | Recipes, purchasing, inventory, waste, and supply risk. |
| `finance` | `finance` | Payments, refunds, FX, revenue, margin, and store P&L. |
| `experience` | `experience` | Support, contacts, experiments, and price tests. |
| `growth` | `growth` | Attribution, loyalty, lifecycle, and customer value. |
| `store_ops` | `store_ops` | Kitchen timing, shifts, quality, incidents, and operating health. |
| `merchandising` | `merchandising` | Menus, availability, price windows, pairings, and substitutions. |
| `planning` | `planning` | Forecasts, capacity, scenarios, and planning exceptions. |
| `legacy` | `legacy` | Intentional migration and refactoring debt. |
| `reliability` | `reliability` | Downstream extension that proves public contracts are usable. |
| `catalog` | `catalog` | Tooling-only project that emits the complete manifest. |

Use [Architecture](docs/architecture.md) for ownership and dependency details.

## Dependency Model

The repo uses two different dependency mechanisms on purpose:

- `shared` is a **code package**, not a deployed dbt Mesh project. Every
  runnable project installs it through `packages.yml`; its protected staging
  models and macros form the deliberate shared implementation boundary.
- Domain-to-domain relationships are **public project interfaces**. They are
  declared in `dependencies.yml`, use public contracted models, and are enforced
  locally with `restrict-access: true`.
- Local domain entries in `packages.yml` are dbt Core fallbacks for those
  project dependencies. They make the monorepo runnable without hosted project
  metadata; they do not turn protected domain models into valid interfaces.
- `catalog` imports every project only to compile one complete manifest.
  Business projects never depend on it.

Keep `shared` and third-party code packages such as `dbt_utils` in
`packages.yml` even when adapting the domain projects to a hosted Mesh setup.

## Ways to Use This Repository

- **Inspect a multi-project architecture:** start with `platform`, then follow
  one downstream lane in the architecture map.
- **Test analytics tooling:** generate the combined manifest and exercise
  lineage, contracts, access rules, semantic models, metrics, and dbt functions.
- **Evaluate an interface change:** modify a public contract and use
  `reliability` to observe the downstream effect.
- **Author an extension:** inspect `reliability` and follow
  [Extension Authoring](docs/extension_authoring.md).
- **Follow optional guided labs:** use labs 1–3 for a quick tour or continue
  through the cross-domain capstone.

The labs are an optional route through the fixture rather than its defining
purpose; their single index is [Labs](docs/labs.md). Model SQL, contract YAML,
and docs live together under:

```text
models/<layer>/<model_name>/<model_name>.sql
models/<layer>/<model_name>/<model_name>.yml
models/<layer>/<model_name>/<model_name>.md
```

## Common Commands

Run commands sequentially because all projects share one local DuckDB file.

| Goal | Command |
| --- | --- |
| Fast setup | `scripts/bootstrap.sh` |
| Setup and compile every project | `scripts/bootstrap.sh --full` |
| Build the first domain | `dbt build --project-dir projects/platform --exclude resource_type:seed` |
| List a domain's public models | `dbt ls --project-dir projects/finance --select access:public --resource-type model` |
| Generate the complete manifest | `scripts/generate_manifest.sh` |
| Generate the full dbt docs site | `scripts/docs.sh generate` |
| Serve generated docs locally | `scripts/docs.sh serve` |
| Lint all project SQL | `scripts/lint_sql_projects.sh` |
| Clean rebuild and validate everything | `scripts/validate_repo.sh` |
| Reset generated state but keep `.venv` | `scripts/clean.sh --keep-venv` |
| Remove all generated local state | `scripts/clean.sh` |

If [Task](https://taskfile.dev/) is installed, `task`, `task setup`,
`task manifest`, `task lint`, and `task validate` are thin wrappers around the
same canonical scripts.

The full validator starts by deleting generated artifacts and the default local
DuckDB database while preserving `.venv`. It then installs packages, lints SQL,
loads seeds, builds every project in dependency order, runs tests and
representative MetricFlow queries, and regenerates `target/manifest.json`.
Use `scripts/clean.sh --dry-run` to preview the complete end-of-session cleanup.

## Where to Make a Change

| Change | Start here |
| --- | --- |
| Synthetic inputs | `projects/shared/seeds/<domain>/` |
| Source declarations or staging cleanup | `projects/shared/models/staging/<domain>/` |
| Column meaning or reusable column docs | [Column Documentation](docs/column-documentation.md) |
| Domain implementation logic | `projects/<domain>/models/intermediate/` |
| Consumer-facing dataset or contract | `projects/<domain>/models/marts/` |
| Cross-row behavior | `projects/<domain>/tests/` |
| Semantic measures or metrics | `projects/<domain>/models/semantic_models.yml` or `projects/<domain>/models/metrics.yml` |
| New downstream use case | `projects/reliability/` or another extension project |
| Deferred project improvements | [TODO](TODO.md) |

## Fixture Contract

- Keep data fictional, compact, deterministic, and safe to publish.
- Depend on public contracted domain models across project boundaries.
- Treat protected domain models as implementation details.
- Keep the `shared` package exception explicit; do not model it as a reciprocal
  project dependency.
- Add complexity only when it supports a named scenario, architectural claim,
  tool-test case, or downstream consumer.
- Do not add real company data, credentials, private schemas, or internal names.
- Do not present this fixture as a production starter kit, performance or
  statistical benchmark, or simulation of deployed dbt Mesh infrastructure.

## More Documentation

- [Getting Started](docs/getting-started.md)
- [Architecture](docs/architecture.md)
- [Company and Fixture Guide](docs/company-and-fixtures.md)
- [Column Documentation](docs/column-documentation.md)
- [Representing Business Capabilities](docs/representing-business-capabilities.md)
- [Labs](docs/labs.md)
- [Extension Authoring](docs/extension_authoring.md)
- [MetricFlow](docs/metricflow.md)
- [Contributing](CONTRIBUTING.md)
- [Security](SECURITY.md)

This project is inspired by dbt Labs'
[jaffle-shop](https://github.com/dbt-labs/jaffle-shop), but it is independently
authored and is not affiliated with or endorsed by dbt Labs. See
[Attribution](ATTRIBUTION.md) for license and contribution boundaries.

Before opening a pull request, run:

```bash
scripts/validate_repo.sh
```
