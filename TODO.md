# Exercise TODOs

This list is intentionally incomplete. The repo is meant to feel like a realistic analytics codebase, so students should discover additional issues through parsing, building, reading lineage, and writing tests.

## Starter Fixes

- Add a scenario-aware key to `jaffle_planning.fct_product_day_forecast_accuracy`. The current model intentionally hints at the problem but does not enforce uniqueness.
- Replace the hard-coded merchandising availability threshold in `jaffle_shared.availability_health` with a project variable.
- Tighten currency naming in `jaffle_merchandising.fct_menu_margin_baseline`; it mixes local prices with USD recipe costs.
- Add model contracts to the most important merchandising and planning marts once students decide which surfaces should be public.
- Extend MetricFlow coverage for substitution readiness and planning exceptions.
- Add accepted-value tests for scenario names, owner roles, and adjustment reasons.
- Convert at least one legacy-style surface into a clean public model with a contract.
- Add a test that catches overlapping capacity scenario windows by store.

## Instructor Notes

Do not treat this file as the full answer key. It names a few low-friction exercises so students can get started, while leaving enough ambiguity for code review, lineage inspection, and semantic-model debugging practice.
