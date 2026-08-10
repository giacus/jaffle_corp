# Column Documentation

Column definitions follow business semantics first and physical lineage second.
The model that establishes a governed business concept owns its docs block;
downstream models and other sources reuse that block until they change the
meaning.

Every model must enumerate its complete output schema in its adjacent `.yml`
file. Every column entry must contain `name`, a `description` that is exactly one
`doc()` reference, and `data_type`. This applies equally to staging,
intermediate, private, ephemeral, and public models.

## Ownership Rules

| Column behavior | Documentation owner |
| --- | --- |
| Governed identifier or reference attribute | The canonical staging entity or reference model in `CANONICAL_COLUMN_OWNERS`. |
| Context-dependent normalized staging output | The exact staging model and column. |
| Same name and value selected downstream | Reuse the upstream block. |
| Same name and value carried through a join | Reuse the upstream block. |
| Stable descriptive attribute selected while deduplicating | Reuse the canonical block. |
| Rename, cast, calculation, aggregation, or classification | Define a block beside the model that performs it. |
| Value selected or coalesced from multiple origins | Define a local block because the choice is new semantics. |
| Lineage is ambiguous | Define locally; do not guess at inheritance. |

For example, `customer_id` identifies the same governed customer whether it is
carried by an order, support ticket, experiment exposure, or finance model. Its
single definition lives beside `stg_customers`:

```jinja
{% docs shared__stg_customers__customer_id %}
Source-system identifier for the customer.
{% enddocs %}
```

Every other model with that exact business identifier references the same block:

```yaml
- name: customer_id
  description: "{{ doc('shared__stg_customers__customer_id') }}"
  data_type: varchar
```

Same spelling alone is not enough to establish shared meaning. Contextual fields
such as loyalty and promotion `event_type`, per-record `updated_at_utc`, and
measures aggregated to a new grain keep model-specific definitions. Names that
are shared only within one lineage branch use the narrower
`CANONICAL_MODEL_COLUMN_OWNERS` mapping. Two local blocks for the same column
name may not repeat identical prose: either reuse one canonical block or state
the distinct record, role, or grain explicitly.

An unchanged downstream passthrough also reuses its upstream reference. It does
not copy the prose into the downstream model's Markdown file:

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
  establishes or changes its meaning.
- Name blocks `<project>__<model>__<column>`, using the exact short dbt project
  name such as `shared` or `platform`.
- Keep every column `description` as a single `doc()` reference.
- Add a repo-wide canonical concept to `CANONICAL_COLUMN_OWNERS` in
  `scripts/check_column_docs.py`; use `CANONICAL_MODEL_COLUMN_OWNERS` only when
  the same column name has different meanings in other lineages.
- Describe business meaning, unit, grain, and important null or fallback
  behavior when those details are not already implied by the owning model.

## Enforcement

`scripts/check_column_docs.py` reads the combined manifest and inspects every
model's DuckDB output: compiled queries for SQL models and built relations for
Python models. It verifies that YAML column names and types exactly match all
model outputs, then traces every column to enforce exact
`doc()` reuse, canonical ownership, placement, and uniqueness. The checker
requires a local definition when lineage is transformed or ambiguous unless an
explicit semantic owner applies, and rejects verbatim same-column definitions
that hide whether the contexts are actually different.

The complete validator builds the required relations, regenerates the manifest,
and runs the checker:

```bash
scripts/validate_repo.sh
```

If the local DuckDB database is already current, run
`scripts/generate_manifest.sh && python scripts/check_column_docs.py` for a
faster documentation-only check.
