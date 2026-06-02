# Architecture

`jaffle-corp` is organized as a small dbt mesh.

The `jaffle_platform` project owns raw source cleanup, conformed dimensions, and stable order-level interfaces. Downstream projects consume those interfaces instead of reaching into staging tables.

The `jaffle_supply` project owns recipe components, purchase orders, inventory counts, waste events, component costs, and supply-risk classification.

The `jaffle_finance` project owns money semantics: payment capture, refunds, FX normalization, and store-level profit and loss. It exposes finance-ready facts for other teams.

The `jaffle_experience` project owns support tickets, contact threads, experiment exposures, and menu price tests. It joins customer experience signals to order and finance truth without leaking implementation models.

The `jaffle_growth` project owns campaign, lifecycle, loyalty, experiment conversion, and customer value semantics. It depends on both behavioral and monetary truth because growth reporting commonly needs both.

The `jaffle_store_ops` project owns kitchen event timing, shifts, quality checks, incidents, and store-day operations by combining platform, supply, and finance facts.

The `jaffle_merchandising` project owns menu publication windows, product-store availability observations, price adjustment windows, menu goals, product pairings, and substitution readiness.

The `jaffle_planning` project owns store-hour forecasts, store-product-day forecasts, component-week plans, operating calendars, capacity scenarios, and forecast exception rollups.

The `jaffle_legacy` project intentionally demonstrates migration debt: inconsistent naming, mixed grains, hand-rolled currency logic, and deprecated marts.

## Intentional Friction

This repo includes realistic friction points:

- Cross-project refs and local package fallbacks.
- Public models with contracts and protected implementation models.
- Multiple metric grains: order, item, customer, store-day, campaign-day, store-hour, product-store-hour, product-store-day, store-product-day, product-pair-day, component-store-week, and scenario-store-day.
- Component, recipe-component, store-component-day, support-ticket, contact-thread, exposure, quality-event, menu-window, forecast, and planning-exception grains.
- Currencies normalized through daily FX rates.
- Refunds, partial captures, loyalty redemptions, component costs, support concessions, shift exceptions, quality checks, and campaign costs.
- Legacy source columns that require normalization before they are usable.
- Snapshots, analyses, exposures, semantic specs, and singular tests as operational surface area.

The merchandising and planning domains intentionally add protected surfaces and lightly documented corners. They are designed to stay fast locally while giving students realistic lineage, ownership, testing, and executable MetricFlow questions to resolve.

## Non-Goals

This repo does not model any real marketplace, payments company, mobility company, or logistics company. The domain is fictional food retail only.
