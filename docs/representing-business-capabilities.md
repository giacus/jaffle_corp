# Representing Business Capabilities

This guide explains how to extend the fictional Jaffle company without turning
the repository into a collection of disconnected dbt examples. Start with a
business capability, place it in the domain that owns it, and use the dbt
feature that expresses it most clearly.

dbt behavior still needs to be understood and verified, but it is an
implementation concern rather than the purpose of the repository. A new asset
should make sense to an analytics engineer even if no downstream extension or
lineage tool ever consumes it.

## Start with the capability

Before choosing a model type, macro, hook, metric, or other dbt mechanism,
complete this sentence:

> The **[domain owner]** uses **[data product or workflow]** to **[business
> action]** because **[business condition]**.

Then identify:

- the decision, workflow, or operating question being supported;
- the domain that owns the result;
- the upstream business inputs;
- the downstream consumer or action;
- the smallest fictional data needed to make the outcome observable;
- the failure that tests or repository validation should catch.

If those points are unclear, the feature does not yet have a natural place in
`jaffle-corp`.

## Keep one executable foundation

The repository currently uses one shared local stack:

- dbt Core `1.11.12`;
- dbt-duckdb `1.10.1`;
- manifest schema v12;
- one DuckDB runtime shared by all projects.

Do not add a parallel project solely to demonstrate a newer dbt version or a
different adapter. If a capability needs another runtime, record it in
[TODO](../TODO.md) and evaluate it as a whole-repository upgrade.

## Decide whether the capability belongs

A new component belongs in the Jaffle estate when all of these are true:

- a realistic analytics or operating team could use it;
- an existing Jaffle domain can own it naturally;
- it has a recognizable input, output, and consumer;
- the pinned dbt and DuckDB stack can execute it end to end;
- it adds a capability not already represented more clearly elsewhere;
- it remains understandable as part of the company without a testing rationale.

Avoid parse-only resources, arbitrary `edge_case_*` models, compatibility
projects, and duplicate syntax variants with no distinct business purpose.

## Respect domain ownership

Prefer extending an existing workflow over inventing a disconnected example:

- `shared` owns raw ingestion, source definitions, and reusable normalization;
- `platform` owns conformed company interfaces and order-pipeline operations;
- business domains own their decisions, metrics, and reporting workflows;
- `legacy` owns migration debt and version-transition examples;
- `reliability` proves that public cross-domain contracts are usable together;
- `catalog` compiles the complete local estate for inspection and validation.

The result should be independently valuable to `jaffle-corp`. External tools
may later use it as a fixture, but they should not determine its vocabulary or
business design.

## Implement a complete vertical slice

The smallest credible capability may include:

- compact fictional input data;
- staging or normalization logic;
- the model, snapshot, function, metric, hook, or other dbt implementation;
- a business-facing consumer or operational action;
- documentation and tests;
- an analysis or query that proves the terminal behavior executes.

Use dbt's public documentation and generated artifacts to confirm ambiguous
implementation details. Inspect source code only when the public contract does
not answer a question; source research is supporting evidence, not a
repository feature.

## Protect the catalog contract

Run the complete catalog compiler after adding or changing a capability:

```bash
scripts/generate_manifest.sh
```

The compiler produces the combined local manifest and then runs
`scripts/check_catalog_contract.py`. The checker protects a curated set of
advertised Jaffle resources, upstream relationships, and intentional authoring
choices. It catches regressions such as a domain workflow silently losing an
input, a version-pinned migration moving to the wrong model, or a YAML snapshot
being replaced by a different surface unintentionally.

This is a repository integrity check. It is not a general manifest parity tool
or an exhaustive inventory of dbt dependencies. Add an assertion only when it
protects a meaningful company workflow or a deliberate part of the reference
architecture.

## Prove execution

Use a focused dbt command while iterating, then run the canonical clean
validation:

```bash
source .venv/bin/activate
scripts/validate_repo.sh
```

The validator installs project dependencies, lints SQL, loads inputs, builds
projects in dependency order, executes project-owned analyses, runs MetricFlow
queries, regenerates the combined catalog, checks its protected contract, and
validates column documentation.

Before publication, repeat bootstrap and validation from a fresh clone at the
candidate commit. This catches ignored local state, undeclared packages, and
assumptions hidden by the working checkout.

## Review the result as part of the company

Before publishing, ask:

- Does the asset sound like part of Jaffle's operations or analytics work?
- Is its domain ownership obvious?
- Can an analytics engineer explain why it exists and what they should do with
  its output?
- Does the complete workflow execute on the one supported runtime?
- Is the implementation smaller than the business capability it represents?
- Could an existing workflow express the same capability more naturally?
- Are unsupported variants deferred honestly instead of simulated?

## Capabilities currently represented

| Capability | Representative assets | Business purpose |
| --- | --- | --- |
| Ingestion assurance | `customer_ingestion_reconciliation`, `order_ingestion_reconciliation`, and `platform_ingestion_reconciliation` | Compare landed customer and order extracts with normalized outputs. |
| Historical state | `customer_profile_snapshot`, `product_catalog_snapshot`, and `customer_profile_history_probe` | Preserve customer and product history for later investigation. |
| Referential integrity | Relationships on `stg_orders` and `stg_order_items` | Verify the links carried by landed order data. |
| Order-pipeline operations | Platform readiness reporting, publication checks, orphan gates, and `order_pipeline_health` | Prevent incomplete order data from reaching public reporting. |
| Customer follow-up | `order_status_follow_up_policy` and `order_customer_follow_up_queue` | Apply an owned response policy to orders that need attention. |
| Legacy migration | Customer migration relation helpers, inventory, and readiness analysis | Compare a pinned legacy contract with its current version. |
| Store reliability | Readiness checks, reliability functions, and `store_reliability_at` | Reuse one store-date reliability decision across operational queries. |
| Campaign economics | `campaign_contribution_usd`, campaign review, and weekly saved query | Review contribution and return through governed metrics. |
| Time-aware measurement | Year-to-date revenue and seven-day experiment conversion | Track progress and outcomes over meaningful business windows. |

## Capability record

Use this compact record in an issue or pull-request description:

```markdown
## Business capability

- Owner:
- User or operating team:
- Decision or action supported:
- Upstream inputs:
- Output and downstream consumer:

## dbt implementation

- Resource or configuration used:
- Why it is the clearest implementation:
- Supported runtime:
- Deferred or unsupported variants:

## Validation

- [ ] Focused build, run, or query
- [ ] `scripts/generate_manifest.sh`
- [ ] `scripts/check_catalog_contract.py` updated if the repository contract changed
- [ ] `scripts/validate_repo.sh`
- [ ] Fresh-clone bootstrap and validation
- [ ] GitHub checks
```

## Definition of done

A capability is complete when it belongs naturally to the fictional company,
executes successfully, has a clear owner and consumer, preserves the intended
catalog contract, passes the complete repository validation, and remains
useful without knowledge of any external tool.
