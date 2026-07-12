# Architecture

`jaffle-corp` is organized as a small dbt mesh plus a downstream extension
fixture.

The `jaffle_shared` project owns the complete ingestion boundary: raw fixture
seeds, source definitions, and domain-organized staging models. It also owns
cross-project macros and schema behavior.

The `jaffle_platform` project owns conformed dimensions and stable order-level
interfaces. Downstream projects consume those interfaces instead of reaching
into shared staging tables.

The `jaffle_supply` project owns recipe components, purchase orders, inventory counts, waste events, component costs, and supply-risk classification.

The `jaffle_finance` project owns money semantics: payment capture, refunds, FX normalization, and store-level profit and loss. It exposes finance-ready facts for other teams.

The `jaffle_experience` project owns support tickets, contact threads, experiment exposures, and menu price tests. It joins customer experience signals to order and finance truth without leaking implementation models.

The `jaffle_growth` project owns campaign, lifecycle, loyalty, experiment conversion, and customer value semantics. It depends on both behavioral and monetary truth because growth reporting commonly needs both.

The `jaffle_store_ops` project owns kitchen event timing, shifts, quality checks, incidents, and store-day operations by combining platform, supply, and finance facts.

The `jaffle_merchandising` project owns menu publication windows, product-store availability observations, price adjustment windows, menu goals, product pairings, and substitution readiness.

The `jaffle_planning` project owns store-hour forecasts, store-product-day forecasts, component-week plans, operating calendars, capacity scenarios, and forecast exception rollups.

The `jaffle_legacy` project intentionally demonstrates migration debt: inconsistent naming, mixed grains, hand-rolled currency logic, and deprecated marts.

The `jaffle_reliability` project is a downstream extension fixture. It consumes
public contracted marts from finance, merchandising, and planning without
depending on their staging or intermediate models.

The `jaffle_catalog` project is tooling-only. It imports every project as a dbt
package so `scripts/generate_manifest.sh` can emit one full-repo
`target/manifest.json`; it must not own business models.

## Dependency Shape

Arrows show the main business-data dependency shape. Catalog-only packaging
edges are omitted:

```mermaid
flowchart LR
    shared["shared ingestion and staging"] --> platform["platform"]
    shared --> supply["supply"]
    shared --> experience["experience"]
    shared --> storeops["store ops"]
    shared --> merchandising["merchandising"]
    shared --> planning["planning"]
    shared --> legacy["legacy"]
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

`jaffle_catalog` observes all of these projects to create the combined manifest;
business projects do not depend on it.

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
