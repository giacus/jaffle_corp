# Column Documentation

Column definitions follow lineage. The model that first gives a column its
business meaning owns the docs block; downstream models reuse that block until
they change the meaning.

Every model must enumerate its complete output schema in its adjacent `.yml`
file. Every column entry must contain `name`, a `description` that is exactly one
`doc()` reference, and `data_type`. This applies equally to staging,
intermediate, private, ephemeral, and public models.

## Ownership Rules

| Column behavior | Documentation owner |
| --- | --- |
| Normalized staging output | The exact staging model and column. |
| Same name and value selected downstream | Reuse the upstream block. |
| Same name and value carried through a join | Reuse the upstream block. |
| Rename, cast, calculation, aggregation, or classification | Define a block beside the model that performs it. |
| Value selected or coalesced from multiple origins | Define a local block because the choice is new semantics. |
| Lineage is ambiguous | Define locally; do not guess at inheritance. |

Staging IDs include the model name so unrelated fields such as loyalty
`event_type` and promotion `event_type` cannot accidentally share a definition:

```jinja
{% docs shared__stg_orders__order_status %}
Normalized lifecycle status of the order.
{% enddocs %}
```

The staging YAML references that block:

```yaml
- name: order_status
  description: "{{ doc('shared__stg_orders__order_status') }}"
  data_type: varchar
```

An unchanged downstream passthrough uses the same reference. It does not copy
the prose into the downstream model's Markdown file:

```yaml
- name: order_status
  description: "{{ doc('shared__stg_orders__order_status') }}"
  data_type: varchar
```

A newly calculated column owns a model-local block and reference:

```jinja
{% docs platform__int_orders_enriched__order_total_usd %}
Order total at order grain, converted to US dollars with the rate for the order date.
{% enddocs %}
```

## File Placement and Names

- Put every column block in the adjacent `.md` file of the model that first
  defines or changes its meaning.
- Name blocks `<project>__<model>__<column>`, using the exact short dbt project
  name such as `shared` or `platform`.
- Keep every column `description` as a single `doc()` reference.
- Describe business meaning, unit, grain, and important null or fallback
  behavior when those details are not already implied by the owning model.

## Enforcement

`scripts/check_column_docs.py` reads the combined manifest and inspects the
compiled DuckDB output for every model. It verifies that YAML column names and
types exactly match all model outputs, then traces every column to enforce exact
`doc()` reuse, block ownership, placement, and uniqueness. The checker requires
a local definition when lineage is transformed or ambiguous.

The complete validator builds the required relations, regenerates the manifest,
and runs the checker:

```bash
scripts/validate_repo.sh
```

If the local DuckDB database is already current, run
`scripts/generate_manifest.sh && python scripts/check_column_docs.py` for a
faster documentation-only check.
