#!/usr/bin/env python3
"""Protect the representative business relationships in the combined manifest."""

from __future__ import annotations

import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MANIFEST = ROOT / "target" / "manifest.json"
EXPECTED_DBT_VERSION = "1.11.12"

REQUIRED_PARENTS = {
    # Core ingestion and model construction.
    "model.shared.stg_orders": {
        "source.shared.platform_app.raw_orders",
        "source.shared.platform_app.raw_customers",
    },
    "model.platform.fct_orders": {
        "model.platform.int_orders_enriched",
        "source.shared.platform_app.raw_orders",
    },
    "model.reliability.fct_store_day_reliability": {
        "model.finance.fct_store_day_revenue_quality",
        "model.merchandising.fct_product_store_day_availability",
        "model.planning.fct_store_day_capacity_plan",
        "function.reliability.reliability_status",
    },
    # Ingestion reconciliation and alternate authoring surfaces.
    "analysis.shared.platform_ingestion_reconciliation": {
        "model.shared.stg_orders",
        "source.shared.platform_app.raw_orders",
    },
    "model.shared.customer_ingestion_reconciliation": {
        "model.shared.stg_customers",
        "source.shared.platform_app.raw_customers",
    },
    "snapshot.platform.customer_profile_snapshot": {"model.shared.stg_customers"},
    "snapshot.shared.product_catalog_snapshot": {
        "source.shared.platform_app.raw_products"
    },
    "analysis.platform.customer_profile_history_probe": {
        "model.platform.dim_customers",
        "snapshot.platform.customer_profile_snapshot",
    },
    # Contracts, hooks, operations, and migration behavior.
    "model.shared.stg_order_items": {
        "source.shared.platform_app.raw_order_items",
        "model.shared.stg_orders",
    },
    "model.platform.int_order_items_enriched": {"model.shared.stg_order_items"},
    "model.platform.fct_order_items": {
        "source.shared.platform_app.raw_order_items",
        "model.platform.int_order_items_enriched",
        "model.platform.fct_orders",
    },
    "operation.platform.platform-on-run-end-0": {"model.platform.fct_orders"},
    "operation.platform.platform-on-run-start-0": {
        "source.shared.platform_app.raw_orders"
    },
    "analysis.legacy.legacy_surface_inventory": {
        "model.legacy.legacy_customer_360.v1",
        "model.legacy.legacy_customer_360.v2",
        "model.legacy.legacy_menu_mix_report_v2",
        "model.legacy.legacy_refund_reason_bridge_v0",
    },
    "analysis.legacy.runtime_customer_migration_readiness": {
        "model.legacy.legacy_customer_360.v1"
    },
    # Functions and their downstream use.
    "function.reliability.current_store_reliability": {
        "function.reliability.reliability_status",
        "model.reliability.fct_store_day_reliability",
    },
    "analysis.reliability.store_day_reliability_probe": {
        "function.reliability.current_store_reliability",
        "model.reliability.fct_store_day_reliability",
    },
    "operation.reliability.reliability-on-run-start-0": {
        "model.finance.fct_store_day_revenue_quality",
        "model.merchandising.fct_product_store_day_availability",
        "model.planning.fct_store_day_capacity_plan",
    },
    # Semantic Layer and reporting surfaces.
    "semantic_model.platform.orders": {"model.platform.fct_orders"},
    "metric.platform.order_count": {"semantic_model.platform.orders"},
    "metric.finance.year_to_date_net_revenue_usd": {
        "semantic_model.finance.order_revenue"
    },
    "metric.growth.campaign_contribution_usd": {
        "metric.growth.attributed_net_revenue_usd",
        "metric.growth.estimated_campaign_cost_usd",
    },
    "metric.growth.campaign_roas": {
        "metric.growth.attributed_net_revenue_usd",
        "metric.growth.estimated_campaign_cost_usd",
    },
    "metric.experience.seven_day_experiment_conversion_rate": {
        "semantic_model.experience.experiment_outcomes",
        "semantic_model.platform.orders",
    },
    "analysis.growth.campaign_performance_review": {
        "model.growth.fct_campaign_performance",
        "metric.growth.campaign_contribution_usd",
    },
    "analysis.experience.order_customer_follow_up_queue": {
        "model.platform.fct_orders",
        "seed.experience.order_status_follow_up_policy",
    },
    "saved_query.growth.weekly_campaign_performance": {
        "metric.growth.campaign_roas",
        "metric.growth.campaign_contribution_usd",
    },
    "exposure.platform.order_pipeline_health": {
        "source.shared.platform_app.raw_orders",
        "model.platform.fct_orders",
        "metric.platform.order_count",
    },
}


# These terminal and alternate-authoring assets intentionally have closed
# parent sets. An unexpected parent is as important as a missing one because it
# changes the business contract advertised by the combined catalog.
EXACT_PARENT_SETS = {
    "analysis.shared.platform_ingestion_reconciliation",
    "model.shared.customer_ingestion_reconciliation",
    "snapshot.platform.customer_profile_snapshot",
    "snapshot.shared.product_catalog_snapshot",
    "analysis.platform.customer_profile_history_probe",
    "model.shared.stg_orders",
    "model.platform.fct_orders",
    "model.platform.fct_order_items",
    "operation.platform.platform-on-run-start-0",
    "operation.platform.platform-on-run-end-0",
    "analysis.legacy.legacy_surface_inventory",
    "analysis.legacy.runtime_customer_migration_readiness",
    "function.reliability.current_store_reliability",
    "analysis.reliability.store_day_reliability_probe",
    "operation.reliability.reliability-on-run-start-0",
    "metric.platform.order_count",
    "metric.finance.year_to_date_net_revenue_usd",
    "metric.growth.campaign_contribution_usd",
    "metric.growth.campaign_roas",
    "metric.experience.seven_day_experiment_conversion_rate",
    "analysis.growth.campaign_performance_review",
    "analysis.experience.order_customer_follow_up_queue",
    "saved_query.growth.weekly_campaign_performance",
    "exposure.platform.order_pipeline_health",
}


EXPECTED_MACRO_CHAINS = {
    "macro.shared.order_ingestion_reconciliation": {
        "macro.shared.platform_ingestion_reconciliation"
    },
    "macro.shared.platform_ingestion_reconciliation": {
        "macro.shared.duckdb__render_platform_ingestion_reconciliation"
    },
    "macro.legacy.stable_customer_migration_relation": {
        "macro.legacy.customer_migration_relation"
    },
    "macro.legacy.current_customer_migration_relation": {
        "macro.legacy.customer_migration_relation"
    },
}


def all_resources(manifest: dict) -> dict[str, dict]:
    resources: dict[str, dict] = {}
    for section in (
        "nodes",
        "sources",
        "exposures",
        "metrics",
        "semantic_models",
        "saved_queries",
        "functions",
    ):
        resources.update(manifest.get(section, {}))
    return resources


def main() -> int:
    manifest_path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_MANIFEST
    if not manifest_path.exists():
        print(f"Missing {manifest_path}", file=sys.stderr)
        return 2

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    resources = all_resources(manifest)
    parent_map = manifest.get("parent_map", {})
    child_map = manifest.get("child_map", {})
    errors: list[str] = []

    dbt_version = manifest.get("metadata", {}).get("dbt_version")
    if dbt_version != EXPECTED_DBT_VERSION:
        errors.append(
            f"expected dbt Core {EXPECTED_DBT_VERSION}, found {dbt_version!r}"
        )

    for child, required_parents in REQUIRED_PARENTS.items():
        resource = resources.get(child)
        if resource is None:
            errors.append(f"missing business resource: {child}")
            continue

        declared_parents = resource.get("depends_on", {}).get("nodes", [])
        declared_parent_set = set(declared_parents)
        for parent in sorted(required_parents):
            if parent not in resources:
                errors.append(f"missing upstream business resource: {parent}")
            if parent not in declared_parent_set:
                errors.append(f"{child} does not declare {parent} as an upstream resource")
            if parent not in parent_map.get(child, []):
                errors.append(f"parent_map is missing {parent} -> {child}")
            if child not in child_map.get(parent, []):
                errors.append(f"child_map is missing {parent} -> {child}")

        if child in EXACT_PARENT_SETS and declared_parent_set != required_parents:
            unexpected = sorted(declared_parent_set - required_parents)
            missing = sorted(required_parents - declared_parent_set)
            errors.append(
                f"{child} has a changed parent contract; "
                f"missing={missing}, unexpected={unexpected}"
            )

    macros = manifest.get("macros", {})
    for macro_id, expected_macros in EXPECTED_MACRO_CHAINS.items():
        macro = macros.get(macro_id)
        if macro is None:
            errors.append(f"missing business macro: {macro_id}")
            continue
        actual_macros = set(macro.get("depends_on", {}).get("macros", []))
        if not expected_macros.issubset(actual_macros):
            errors.append(
                f"{macro_id} is missing nested macro calls "
                f"{sorted(expected_macros - actual_macros)}"
            )

    repeated_parent = "model.platform.fct_order_items"
    basket_model = resources.get("model.merchandising.int_basket_pair_observations", {})
    basket_parents = basket_model.get("depends_on", {}).get("nodes", [])
    if basket_parents.count(repeated_parent) != 1:
        errors.append(
            "basket-pair observations must serialize its repeated order-item ref once"
        )

    python_audit = resources.get("model.shared.customer_ingestion_reconciliation", {})
    if python_audit.get("language") != "python":
        errors.append("customer ingestion reconciliation must remain a Python model")

    yaml_snapshot = resources.get("snapshot.shared.product_catalog_snapshot", {})
    if not str(yaml_snapshot.get("original_file_path", "")).endswith(".yml"):
        errors.append("product catalog history must remain a YAML-authored snapshot")

    legacy_model = resources.get("model.legacy.legacy_customer_360.v1", {})
    if legacy_model.get("version") != 1:
        errors.append("the pinned legacy customer migration interface must remain version 1")

    latest_legacy_model = resources.get("model.legacy.legacy_customer_360.v2", {})
    if latest_legacy_model.get("version") != 2:
        errors.append("the current legacy customer migration interface must remain version 2")

    growth_review = resources.get("analysis.growth.campaign_performance_review", {})
    if growth_review.get("metrics") != [["campaign_contribution_usd"]]:
        errors.append(
            "the campaign review must identify its governed contribution metric"
        )

    reliability_probe = resources.get(
        "analysis.reliability.store_day_reliability_probe", {}
    )
    if reliability_probe.get("functions") != [["current_store_reliability"]]:
        errors.append(
            "the reliability probe must use the canonical store-date lookup function"
        )

    if errors:
        print("Manifest graph checks failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1

    relationship_count = sum(len(parents) for parents in REQUIRED_PARENTS.values())
    print(
        "Manifest graph: "
        f"{len(REQUIRED_PARENTS)} business resources and "
        f"{relationship_count} required relationships verified."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
