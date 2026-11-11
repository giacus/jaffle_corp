# Order-audit source selection

This small project exercises the same business rule on dbt Core 1.x and native
dbt 2.x. An order audit normally reads `stg_orders`; the
`orders_relation_override` variable can select `expedited_orders` instead.
The relation lives in a block-form Jinja string under `vars`, and a macro reads
it. Only the selected branch contributes a dependency.

The schema also uses scalar model/source tags and sequence table tags. A doc
block and a macro keep source navigation observable. The project is separate
from the twelve maintained warehouse projects and needs no warehouse data for
manifest parsing.

Local order sketches live under `drafts/` and are excluded through `.dbtignore`.
Their models, macros and doc blocks must stay out of the manifest. A dot-prefixed
SQL filename checks native dbt's separate basename exclusion.

`order_lineage_audit` records the chosen order relation before calling a dbt
timestamp macro. Its run/build branch selects that same relation; parsing must
keep only the selected dependency. This catches readers that fall back to
collecting references from every branch after an unrelated macro call.

`order_totals` chooses incremental or table materialization through a macro in
an ordinary `config()` call. The `audit_force_full_rebuild` variable switches
that choice. `published_order_audit` inherits a Jinja materialization from the
project YAML: a view for the `preview` target and a table for `dev`.

Copy `profiles.example.yml` to a private profiles directory as `profiles.yml`,
then run `dbt parse --project-dir . --profiles-dir <directory>`. Repeat with
`--vars '{"orders_relation_override": "expedited_orders"}'`. The audit edge
must move from `stg_orders` to `expedited_orders`; the source, model and table
tags remain present in both manifests.

Run this from the repository root:

```sh
python scripts/verify_source_context_graph.py --dbt <executable> --out <report.json>
```

It creates isolated temporary copies and leaves the authored fixture untouched.
The four cases combine both order-source choices with the two target/rebuild
settings and verify their native manifest dependencies and materializations.
