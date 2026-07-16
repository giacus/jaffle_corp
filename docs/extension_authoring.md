# Extension Authoring

Use this guide when you want to build a downstream dbt project that relies on
`jaffle-corp` instead of editing the core domains directly.

The reference implementation is `projects/reliability`. It consumes
public contracted marts from finance, merchandising, and planning, then adds its
own model, contract, tests, and analysis.

## Rules

- Depend on public models only.
- Treat protected staging and intermediate models as implementation details.
- Define the downstream model grain before choosing upstream refs.
- Add a model contract for every extension mart that should be reused.
- Keep extension-specific logic in the extension project.
- Run the upstream stack before iterating on an extension model in local dbt
  Core.

## Local dbt Core Pattern

Inside this monorepo, keep extension fixtures under `projects/` so local package
paths resolve as siblings:

```text
projects/reliability
```

The extension should include:

- `dbt_project.yml` for its own schemas, tags, and default materialization.
- `packages.yml` with `shared` as a code package plus local dbt Core fallbacks
  for the upstream domain projects it consumes.
- `dependencies.yml` with only the intended public domain-project dependencies;
  do not declare `shared` as a peer project dependency.
- `models/marts/<model>/<model>.yml` with public access and enforced contracts
  for reusable extension marts.
- `models/marts/<model>/<model>.md` with model-local docs blocks.
- Singular tests for behavior that generic tests cannot express.
- Analyses that demonstrate useful exploratory queries without becoming
  production marts.

Build from the repo root:

```bash
scripts/validate_repo.sh
```

Iterate on only the extension after upstream projects have been built:

```bash
dbt deps --project-dir projects/reliability
dbt build --project-dir projects/reliability --select reliability
```

This local package fallback makes every upstream project's source code part of
the consumer parse. It preserves project names, two-argument `ref()` calls, and
access checks, but it is not a deployed dbt Mesh: the consumer is responsible
for installing and building the upstream code in its own target.

## Public Interfaces To Start From

Good first upstream refs for extension projects:

- `ref('finance', 'fct_store_day_revenue_quality')`
- `ref('merchandising', 'fct_product_store_day_availability')`
- `ref('merchandising', 'fct_substitution_readiness')`
- `ref('planning', 'fct_store_day_capacity_plan')`
- `ref('planning', 'fct_planning_exception_daily')`

Before adding a new upstream dependency, inspect the model YAML and confirm:

- `access: public`
- `contract.enforced: true`
- the grain is documented by key columns and tests
- the needed column names and data types are part of the contract

## Extension in a Separate Repository

An external repository makes the ownership boundary more realistic. Choose the
dependency pattern based on where the extension will run:

| Runtime | Dependency mechanism | What the consumer receives |
| --- | --- | --- |
| Local dbt Core | A pinned checkout of `jaffle-corp` plus local packages | Upstream source code, which the consumer parses and builds |
| Hosted dbt Mesh | Project dependencies in `dependencies.yml` | Metadata-backed access to already-built public models |

These are deliberately different. A local package is code reuse; a hosted
project dependency is a deployed data-product interface. See dbt's official
[package documentation](https://docs.getdbt.com/docs/build/packages) and
[project-dependency documentation](https://docs.getdbt.com/docs/mesh/govern/project-dependencies)
for the platform requirements and current behavior.

### Working Local Core Example

For local Core, keep the extension as its own Git repository but place its
checkout beside the pinned upstream projects. The filesystem relationship is
required because this fixture's local package fallbacks use paths such as
`../shared`:

```bash
git clone https://github.com/giacus/jaffle_corp.git jaffle-corp-workspace
git -C jaffle-corp-workspace switch --detach origin/master
git -C jaffle-corp-workspace rev-parse HEAD
git clone https://github.com/your-org/store-watchlist.git \
  jaffle-corp-workspace/projects/store-watchlist
cd jaffle-corp-workspace/projects/store-watchlist
```

The nested extension checkout has its own `.git` directory and remote; it is
not committed to `jaffle-corp`. Add its path to the parent checkout's local
`.git/info/exclude` if you do not want the parent repository to report it as
untracked. Record the full commit printed by `rev-parse` in the extension's own
setup documentation or a small version file so every contributor checks out
the same upstream baseline.

The workspace should have this shape:

```text
jaffle-corp-workspace/         # upstream checkout at the recorded commit
└── projects/
    ├── shared/
    ├── platform/
    ├── supply/
    ├── finance/
    └── store-watchlist/          # independent Git repository
        ├── dbt_project.yml
        ├── dependencies.yml
        ├── models/
        │   ├── _groups.yml
        │   └── fct_store_day_watchlist/
        │       ├── fct_store_day_watchlist.md
        │       ├── fct_store_day_watchlist.sql
        │       └── fct_store_day_watchlist.yml
        └── packages.yml
```

Use the same sibling paths as the in-repository extension in `packages.yml`:

```yaml
packages:
  - local: ../shared
  - local: ../platform
  - local: ../supply
  - local: ../finance
```

Declare Finance as the public project interface in `dependencies.yml`, just as
the in-repository extension does:

```yaml
projects:
  - name: finance
```

The external project's `dbt_project.yml` can stay small:

```yaml
name: store_watchlist
version: "0.1.0"
config-version: 2

profile: jaffle_corp
require-dbt-version: "=1.11.12"
restrict-access: true

model-paths: ["models"]

models:
  store_watchlist:
    +materialized: view
    +group: reliability
```

Declare the owning group in `models/_groups.yml`:

```yaml
version: 2

groups:
  - name: reliability
    owner:
      name: Store Reliability Team
```

The model uses only the producer's public, contracted interface:

```sql
-- models/fct_store_day_watchlist/fct_store_day_watchlist.sql
select
    store_day_revenue_quality_key as store_day_watchlist_key,
    store_id,
    recognized_date,
    net_revenue_usd,
    refund_order_rate,
    revenue_exception_rate,
    refund_order_rate > 0 or revenue_exception_rate > 0 as needs_review
from {{ ref('finance', 'fct_store_day_revenue_quality') }}
```

Spell out the complete output contract in
`models/fct_store_day_watchlist/fct_store_day_watchlist.yml`:

```yaml
version: 2

models:
  - name: fct_store_day_watchlist
    description: "{{ doc('store_watchlist__fct_store_day_watchlist') }}"
    config:
      access: public
      contract:
        enforced: true
    columns:
      - name: store_day_watchlist_key
        description: "{{ doc('store_watchlist__fct_store_day_watchlist__store_day_watchlist_key') }}"
        data_type: varchar
        data_tests: [not_null, unique]
      - name: store_id
        description: "{{ doc('finance__int_order_payment_allocations__store_id') }}"
        data_type: varchar
      - name: recognized_date
        description: "{{ doc('finance__fct_order_revenue__recognized_date') }}"
        data_type: date
      - name: net_revenue_usd
        description: "{{ doc('finance__int_store_day_revenue_quality__net_revenue_usd') }}"
        data_type: double
      - name: refund_order_rate
        description: "{{ doc('finance__int_store_day_revenue_quality__refund_order_rate') }}"
        data_type: double
      - name: revenue_exception_rate
        description: "{{ doc('finance__int_store_day_revenue_quality__revenue_exception_rate') }}"
        data_type: double
      - name: needs_review
        description: "{{ doc('store_watchlist__fct_store_day_watchlist__needs_review') }}"
        data_type: boolean
```

Only the model, renamed key, and calculated flag need local definitions in
`fct_store_day_watchlist.md`; unchanged columns reuse their producer blocks:

```jinja
{% docs store_watchlist__fct_store_day_watchlist %}
Store-day revenue outcomes that need a reliability review.
{% enddocs %}

{% docs store_watchlist__fct_store_day_watchlist__store_day_watchlist_key %}
Stable key for the store and recognized date in the watchlist.
{% enddocs %}

{% docs store_watchlist__fct_store_day_watchlist__needs_review %}
True when refunds or revenue exceptions are present.
{% enddocs %}
```

Install the pinned toolchain, load the raw fixture, and build the model with its
ancestors:

```bash
../../scripts/bootstrap.sh
source ../../.venv/bin/activate
dbt deps --project-dir .
dbt seed --project-dir .
dbt build --project-dir . \
  --select +fct_store_day_watchlist \
  --exclude resource_type:seed
```

Commit the generated `package-lock.yml` and the documented upstream revision to
the extension repository. A `local:` entry cannot record the upstream Git
revision by itself. Do not tell contributors to use a moving branch such as
`main` or `master`; require a published release tag or a full
40-character commit hash in the workspace setup.

#### Why Not Install Every Domain Directly from Its Git Subdirectory?

dbt supports Git packages with a `revision` and `subdirectory`, and that is a
good option for a self-contained package. For example, an extension that needs
only shared macros could pin `projects/shared` directly:

```yaml
packages:
  - git: https://github.com/giacus/jaffle_corp.git
    revision: "<release-tag-or-full-sha>"
    subdirectory: projects/shared
```

The domain projects in this fixture also declare sibling local fallbacks such
as `../shared` and `../platform`. Installing one domain through an isolated
sparse subdirectory would remove that sibling layout. Placing the separately
versioned extension beside a pinned full checkout avoids fragile path rewriting
and lets local Core exercise the same graph as the monorepo.

### Hosted Project-Dependency Example

In a supported dbt Mesh deployment, do not install upstream domain source code
as a fallback. Declare only the producers whose public models the extension
uses:

```yaml
# dependencies.yml
projects:
  - name: finance
```

Keep the same two-argument ref:

```sql
{{ ref('finance', 'fct_store_day_revenue_quality') }}
```

The producer must have a successful deployment that exposes a current manifest
and the referenced model must be `access: public`. Hosted project dependencies
resolve that deployed relation through metadata; they do not ask the consumer
to build finance. Remove the finance local package when switching to this mode.
Keep `shared` as a package only if the extension calls its macros; it is
not a peer project dependency in this fixture.

### Upgrade a Pinned Extension Safely

Treat an upstream release change like an API upgrade:

1. Fetch the new upstream tag in the parent `jaffle-corp` checkout and inspect
   its release notes.
2. Check out the chosen tag or full commit and update the extension's recorded
   upstream revision in the same change.
3. Run `dbt clean` and `dbt deps`, then commit the refreshed
   `package-lock.yml`.
4. Run `dbt parse` before building to catch missing refs and access violations.
5. Build the extension with its ancestors and run its behavior tests and
   analyses.
6. Review upstream public-model contracts for removed, renamed, or retyped
   columns even when compilation succeeds.

For hosted Mesh, perform the same consumer validation against the producer's
staging deployment before promoting the producer release.

## Review Checklist

- Does the extension avoid refs to `staging` and `intermediate` models?
- Does `dependencies.yml` contain domain producers only, with code packages
  kept in `packages.yml`?
- Does every new mart have a stable key and a declared grain?
- Would changing an upstream contracted column break this extension loudly?
- Is there at least one test that protects the extension's business logic?
- Can a student understand the model from lineage, YAML, and one analysis query?
- Is an external checkout pinned to a tag or full commit rather than a moving
  branch?
- Does the documentation say whether the extension is using local package code
  or hosted project metadata?
