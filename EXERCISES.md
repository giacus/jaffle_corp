# Exercise Lab Catalog

These labs are for learners who know basic dbt commands and want practice in a
larger, multi-project codebase. They preserve room for judgment, but each one has
a concrete starting point and feedback loop.

For a sequenced workshop, use [docs/course_path.md](docs/course_path.md). For an
individual challenge, choose a lab by level and time.

## Before Any Lab

From the repository root:

```bash
scripts/bootstrap.sh
source .venv/bin/activate
dbt seed --project-dir projects/jaffle_platform
dbt build --project-dir projects/jaffle_platform --exclude resource_type:seed
```

Commands below assume the patched venv is active. Run project builds
sequentially because every project shares one local DuckDB file.

`scripts/validate_repo.sh` recreates the default local database. Commit or stash
useful work before a destructive experiment, and restore any intentionally
broken seed before running the full validator.

## Lab 1: Trace Recognized Revenue

- **Level:** guided
- **Time:** 20–30 minutes
- **Practice:** selection syntax, lineage, public interfaces, tests

Start here:

- `projects/jaffle_finance/models/marts/fct_order_revenue/fct_order_revenue.sql`
- `projects/jaffle_finance/models/marts/fct_order_revenue/fct_order_revenue.yml`
- `projects/jaffle_finance/packages.yml`

Run:

```bash
dbt deps --project-dir projects/jaffle_finance

dbt ls --project-dir projects/jaffle_finance \
  --select +fct_order_revenue \
  --resource-type model

dbt ls --project-dir projects/jaffle_finance \
  --select fct_order_revenue \
  --resource-type test

dbt build --project-dir projects/jaffle_finance \
  --select +fct_order_revenue
```

Answer:

1. What is the grain of `fct_order_revenue`?
2. Which upstream projects provide its public inputs?
3. Which tests attach directly to this model, rather than to an ancestor?
4. Which columns make it safe or unsafe as a downstream interface?

**Done:** you can narrate the path from platform orders and items to recognized
finance revenue without reading every finance model.

<details>
<summary>Hint</summary>

Use `packages.yml` to distinguish package boundaries, and use the model YAML—not
only the SQL—to find access, contract, grain, and direct tests.

</details>

## Lab 2: Prove a Test Can Fail

- **Level:** guided
- **Time:** 20 minutes
- **Practice:** seeds, generic tests, controlled failure and recovery

Start here:

- `projects/jaffle_merchandising/seeds/raw_price_adjustments.csv`
- `projects/jaffle_merchandising/models/staging/stg_price_adjustments/stg_price_adjustments.yml`

1. Save a temporary copy of the seed.
2. Duplicate one data row so two rows have the same `price_adjustment_id`.
3. Run the focused seed and build:

```bash
dbt deps --project-dir projects/jaffle_merchandising
dbt seed --project-dir projects/jaffle_merchandising \
  --select raw_price_adjustments --full-refresh
dbt build --project-dir projects/jaffle_merchandising \
  --select stg_price_adjustments
```

4. Confirm the uniqueness test fails and read the compiled failure query.
5. Restore the original seed and rerun both commands until they pass.

Keep the temporary copy outside the repository, or remove it when you finish.

**Done:** the focused build passes after you have observed the expected failure
once, and this seed-specific check is clean:

```bash
git diff --exit-code -- \
  projects/jaffle_merchandising/seeds/raw_price_adjustments.csv
```

## Lab 3: Navigate the Full Manifest

- **Level:** guided
- **Time:** 20–30 minutes
- **Practice:** dbt artifacts, package ownership, access, lineage

Generate the monorepo artifact:

```bash
scripts/generate_manifest.sh
```

Use `target/manifest.json` to answer:

1. Which packages contain executable nodes?
2. How many public models does each package expose?
3. Which public models have enforced contracts?
4. What are the direct parents and children of `fct_store_day_reliability`?
5. Which `original_file_path` defines `fct_order_revenue`, the upstream model
   supplying `net_revenue_usd` to reliability?

Useful starting query:

```bash
jq -r '
  .nodes
  | to_entries[]
  | select(.value.resource_type == "model" and .value.config.access == "public")
  | [.value.package_name, .value.name, .value.config.contract.enforced]
  | @tsv
' target/manifest.json
```

If `jq` is unavailable, the required Python environment can provide the package
list:

```bash
python - <<'PY'
import json
from pathlib import Path

manifest = json.loads(Path("target/manifest.json").read_text())
print(*sorted({node["package_name"] for node in manifest["nodes"].values()}), sep="\n")
PY
```

**Done:** you can locate a model's owner, original file, access, contract, and
graph links without searching the repository by hand.

## Lab 4: Protect a Price-Window Invariant

- **Level:** intermediate
- **Time:** 45–60 minutes
- **Practice:** singular tests, interval logic, focused validation

Create `projects/jaffle_merchandising/tests/assert_price_adjustment_windows_do_not_overlap.sql`.
Start here:

- `projects/jaffle_merchandising/models/staging/stg_price_adjustments`
- `projects/jaffle_merchandising/models/marts/fct_price_adjustment_windows`
- `projects/jaffle_merchandising/tests`

Add a singular test that returns rows when two price-adjustment windows overlap
for the same product and store. Decide whether touching endpoints count as an
overlap and document that choice in the SQL.

Verify:

```bash
dbt deps --project-dir projects/jaffle_merchandising
dbt seed --project-dir projects/jaffle_merchandising \
  --select raw_price_adjustments --full-refresh
dbt build --project-dir projects/jaffle_merchandising \
  --select +fct_price_adjustment_windows
dbt test --project-dir projects/jaffle_merchandising \
  --select assert_price_adjustment_windows_do_not_overlap
```

**Done:** the current fixture passes, a temporary overlapping row makes your new
test fail, and removing that row makes it pass again. Rerun the focused `dbt
seed` after both adding and removing the temporary row.

## Lab 5: Review a Contract Change Before Coding

- **Level:** intermediate
- **Time:** 30–45 minutes
- **Practice:** public access, contracts, downstream blast radius, code review

Choose one public model used by `jaffle_reliability`. Use its YAML and
`target/manifest.json` to write a short design note containing:

- one backward-compatible change;
- one breaking change;
- the exact downstream nodes affected;
- a migration plan for the breaking change;
- the focused dbt commands that would validate it.

Do not implement the breaking change.

Run `scripts/generate_manifest.sh` first so the artifact is current.

**Done:** another engineer could turn the note into a safe pull request without
having to rediscover the consumers.

## Lab 6: Observe Snapshot History

- **Level:** intermediate
- **Time:** 30–45 minutes
- **Practice:** snapshots, timestamp strategy, SCD history

Start here:

- `projects/jaffle_platform/snapshots/customer_profile_snapshot.sql`
- `projects/jaffle_platform/seeds/raw_customers.csv`

1. Build platform and run `customer_profile_snapshot` once.
2. Save the seed, change one customer's descriptive field, and advance that
   row's `updated_at` value.
3. Reseed and rerun the snapshot.
4. Use `dbt show --inline` with a `ref` to inspect both versions and dbt's
   validity columns.
5. Restore the seed and reseed the raw table.

```bash
dbt snapshot --project-dir projects/jaffle_platform \
  --select customer_profile_snapshot

dbt seed --project-dir projects/jaffle_platform \
  --select raw_customers --full-refresh

dbt show --project-dir projects/jaffle_platform --inline \
  "select customer_id, dbt_valid_from, dbt_valid_to from {{ ref('customer_profile_snapshot') }} order by customer_id, dbt_valid_from"
```

**Done:** you can explain why only a later timestamp creates a new version, and
the seed and raw table are restored before you finish. The snapshot intentionally
keeps its observed history; run `scripts/validate_repo.sh` if you want to recreate
the whole local database from a clean baseline.

## Lab 7: Refactor a Legacy Interface Safely

- **Level:** advanced
- **Time:** 60–90 minutes
- **Practice:** migration, compatibility, exposures, characterization tests

Start with:

- `projects/jaffle_legacy/models/marts/legacy_daily_store_rollup`
- `projects/jaffle_legacy/models/exposures.yml`

Before refactoring, capture a baseline row count and representative totals with
`dbt show --inline`. Add a characterization test for the behavior the exposure
relies on. Then build a cleaner replacement or adapter while keeping the
documented external result compatible.

```bash
dbt deps --project-dir projects/jaffle_legacy
dbt build --project-dir projects/jaffle_legacy \
  --select +legacy_daily_store_rollup
dbt show --project-dir projects/jaffle_legacy --inline \
  "select count(*) as row_count from {{ ref('legacy_daily_store_rollup') }}"
```

**Done:** you have a before/after comparison, a passing compatibility test, and
a written statement of what improved versus what intentionally stayed awkward.
Rerun the focused build and select your new characterization test by name before
finishing.

## Lab 8: Cross-Domain Support Capstone

- **Level:** advanced
- **Time:** 2–4 hours
- **Practice:** grain design, project dependencies, contracts, cross-domain tests

Business question:

> Do orders that miss the kitchen ready target generate more support demand,
> worse SLA outcomes, or lower satisfaction?

Use only these public contracted inputs:

- `jaffle_store_ops.fct_order_service_times`
- `jaffle_experience.fct_support_tickets`

Choose an order or ticket grain before writing SQL. Then add a downstream model,
contract, documentation, a behavioral test, and an analysis query. You may extend
`jaffle_reliability` or create a second extension project.

If you create another project, also register it in:

- `Taskfile.yml` and `scripts/validate_repo.sh` at the correct dependency point;
- `projects/jaffle_catalog/packages.yml`, so the full manifest includes it;
- `docs/architecture.md`, so a new learner can find it.

**Done:** focused upstream and downstream builds pass, the model uses no
protected refs, its grain is enforced by tests, and `scripts/validate_repo.sh`
still passes.

## Open-Ended Stretch Ideas

- Add a variable-controlled threshold to one mart and prove both branches.
- Extract a repeated business expression into `jaffle_shared` with examples or
  tests that justify the abstraction.
- Extend MetricFlow coverage for substitution readiness or planning exceptions.
- Add a saved query only after naming a real repeated consumer and query.
- Add a dbt unit test, an incremental model with a full-refresh comparison, or a
  state-based selection workflow if you want surfaces beyond the current scope.

## Notes for Instructors

These labs provide expected observations, not an answer key. Ask learners to
explain grain, ownership, and validation choices in review; a green command alone
does not prove the design is sound.
