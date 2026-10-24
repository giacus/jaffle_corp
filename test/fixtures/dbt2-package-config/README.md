# Package configuration for settlement reconciliation

This isolated dbt 2 example lets the reconciliation project own the storage
policy of a local settlement-policy package. It does not modify projects/ or
the separate builtin-wrapper fixture.

The package contributes a default tag and view materialization. Its property
configuration contributes policy_contract and ephemeral materialization; its
SQL contributes policy_inline, view materialization and enabled=false. The
controlling project explicitly re-enables settlement_events, stores it as a
table, appends reconciliation_owner and adds a reconciliation-window hook.

Native dbt 2 applies the dependency's controlling-root overlay after project,
property and inline configuration. The expected settlement_events tags are
policy_defaults, policy_contract, policy_inline, reconciliation_owner, in that
order. It is active and materialized as a table. All hook declarations remain
present; their final order is a separate native merge behavior.

The graph has three models and two edges: customer_settlements depends on the
package's settlement_events, which depends on reconciliation_window through
the controlling project's hook. No missing-target nodes are introduced.

Copy this whole directory to an isolated temporary location, copy
profiles.example.yml to profiles.yml there, then use an explicit official
dbt 2.0.9 executable for deps and parse/list. Full run/warehouse validation has
not been performed. Record the source fingerprint with each native receipt;
the source reference is public dbt 2.0.8 at
43918198c2f02366ceb33f60006812872b0bab40, separately from the 2.0.9 binary.
