# Architecture

`jaffle-corp` is a Mesh-inspired local dbt monorepo plus a downstream extension
fixture. It demonstrates public interfaces and project boundaries without
pretending that local package installation is the same as deployed dbt Mesh.

For the fictional company flow and the intentional data edge cases behind this
graph, read [Company and Fixture Guide](company-and-fixtures.md).

The `shared` project owns the complete ingestion boundary: raw fixture
seeds, source definitions, domain-organized staging models, cross-project
macros, and schema behavior. It is deliberately installed as a code package.

The `platform` project owns conformed dimensions and stable order-level
interfaces. Downstream projects consume those interfaces instead of reaching
into shared staging tables.

The `supply` project owns recipe components, purchase orders, inventory counts, waste events, component costs, and supply-risk classification.

The `finance` project owns money semantics: payment capture, refunds, FX normalization, and store-level profit and loss. It exposes finance-ready facts for other teams.

The `experience` project owns support tickets, contact threads, experiment exposures, and menu price tests. It joins customer experience signals to order and finance truth without leaking implementation models.

The `growth` project owns campaign, lifecycle, loyalty, experiment conversion, and customer value semantics. It depends on both behavioral and monetary truth because growth reporting commonly needs both.

The `store_ops` project owns kitchen event timing, shifts, quality checks, incidents, and store-day operations by combining platform, supply, and finance facts.

The `merchandising` project owns menu publication windows, product-store availability observations, price adjustment windows, menu goals, product pairings, and substitution readiness.

The `planning` project owns store-hour forecasts, store-product-day forecasts, component-week plans, operating calendars, capacity scenarios, and forecast exception rollups.

The `legacy` project intentionally demonstrates migration debt:
inconsistent naming, mixed grains, hand-rolled currency logic, and deprecated
marts. Its intermediate compatibility adapters reshape public upstream models;
they are not part of the shared source-ingestion boundary.

The `reliability` project is a downstream extension fixture. It consumes
public contracted marts from finance, merchandising, and planning without
depending on their staging or intermediate models.

The `catalog` project is tooling-only. It imports every project as a dbt
package so `scripts/generate_manifest.sh` can emit one full-repo
`target/manifest.json`; it must not own business models.

## Dependency Shape

The graph uses dotted arrows for protected models supplied through the local
`shared` package and solid arrows for domain-to-domain public interfaces.
Catalog-only packaging edges are omitted:

```mermaid
flowchart LR
    shared["shared ingestion and staging"] -.-> platform["platform"]
    shared -.-> supply["supply"]
    shared -.-> experience["experience"]
    shared -.-> storeops["store ops"]
    shared -.-> merchandising["merchandising"]
    shared -.-> planning["planning"]
    shared -.-> legacy["legacy"]
    platform --> supply["supply"]
    platform --> finance["finance"]
    supply --> finance
    platform --> experience
    finance --> experience
    platform --> growth["growth"]
    finance --> growth
    experience --> growth
    platform --> storeops
    supply --> storeops
    finance --> storeops
    platform --> merchandising
    supply --> merchandising
    platform --> planning
    supply --> planning
    finance --> planning
    storeops --> planning
    platform --> legacy
    finance --> legacy
    experience --> legacy
    finance --> reliability["reliability extension"]
    merchandising --> reliability
    planning --> reliability
```

`catalog` observes all of these projects to create the combined manifest;
business projects do not depend on it.

## Package Boundary vs Project Boundary

These relationships are intentionally different:

| Relationship | Declared in | Access rule | Purpose |
| --- | --- | --- | --- |
| Project to `shared` | `packages.yml` | Protected staging is allowed because `shared` sets `restrict-access: false`. | Centralized local ingestion, staging, macros, and fixture seeds. |
| Domain to domain | `dependencies.yml` | Producers set `restrict-access: true`; consumers use public models only. | Stable cross-domain data interfaces. |
| Local domain fallback | `packages.yml` | The same public-only policy is enforced by the producer. | Run dbt Core without hosted project metadata. |
| Catalog observation | `projects/catalog/packages.yml` | Compile-only; no business ownership. | Emit one complete manifest for tooling. |

`shared` is therefore a one-way package dependency, not a peer domain and not a
reciprocal project dependency. Domain projects may consume its protected
staging models, but `shared` must not depend on domain models. Third-party code
packages such as `dbt_utils` follow the same package mechanism and remain in
`packages.yml` in local and hosted environments.

Column meaning follows the same ownership boundary. Each normalized staging
output owns its canonical docs block. A downstream column that preserves the
same name and value references that exact block; a rename, cast, calculation,
aggregation, or multi-source choice owns a model-local definition. See
[Column Documentation](column-documentation.md) for the convention and its
automated lineage check.

## Domain Map

Platform:

- Customers, stores, products, supplies, orders, order items, payments, and
  refunds.

Finance:

- Captured payments, refunds, FX-normalized revenue, recipe-derived margin,
  component cost variance, controls, and daily store profit and loss.

Supply:

- Recipe components, purchase orders, receipts, inventory counts, waste events,
  and component-day risk classification.

Experience:

- Support tickets, contact threads, menu price tests, experiment exposures, and
  seven-day experiment outcomes.

Growth:

- Campaign events, loyalty events, lifecycle, campaign performance, experiment
  conversion, customer value, acquisition, and repeat-purchase metrics.

Store Ops:

- Kitchen timing, shifts, quality checks, incidents, and store-day operating
  health.

Merchandising:

- Menu publication windows, product availability, temporary price adjustments,
  product-pair affinity, substitution readiness, menu goals, and menu margin
  baselines.

Planning:

- Store-hour forecasts, store-product-day forecasts, component-week plan
  variance, capacity planning, operating calendars, capacity scenario windows,
  and planning exception rollups.

Reliability Extension:

- Downstream public-contract consumption, store-day revenue quality plus
  availability, capacity-plan context, and extension-safe tests.

Legacy:

- Deprecated daily store rollups, customer rollups, menu mix reports, old order
  status mappings, mixed currency calculations, and intentionally confusing
  tables for migration exercises.

## Intentional Friction

This repo includes realistic friction points:

- Cross-project refs and local package fallbacks.
- Public models with contracts, protected implementation models, and one
  downstream extension that proves the contracts are usable.
- Multiple metric grains: order, item, customer, store-day, campaign-day, store-hour, product-store-hour, product-store-day, store-product-day, product-pair-day, component-store-week, and scenario-store-day.
- Component, recipe-component, store-component-day, support-ticket, contact-thread, exposure, quality-event, menu-window, forecast, and planning-exception grains.
- Currencies normalized through daily FX rates.
- Refunds, partial captures, loyalty redemptions, component costs, support concessions, shift exceptions, quality checks, and campaign costs.
- Legacy source columns that require normalization before they are usable.
- Snapshots, analyses, exposures, semantic models, MetricFlow queries, and singular tests as operational surface area.

The merchandising and planning domains now expose contracted public marts across
product availability, menu margin, forecast accuracy, capacity planning, and
plan variance. The reliability extension is intentionally small so students can
inspect whether those public interfaces are sufficient before they add another
downstream dependency or change an upstream contract.

## Non-Goals

This repo does not model any real marketplace, payments company, mobility company, or logistics company. The domain is fictional food retail only.
