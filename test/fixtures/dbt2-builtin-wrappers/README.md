# dbt built-in resolver wrappers

This isolated settlement-reconciliation example exercises the `builtins`
namespace and aliases to its resolver functions. It lives outside `projects/`
and does not change the maintained multi-project graph.

`gateway_settlements` delegates to `builtins.source`; `settlement_input`
aliases the namespace and its `ref` function before resolving the staging
model. A Jinja `namespace` retains the selected model through its loop before
the resolver is called. The customer totals model applies `builtins.config`, including table
materialization, a tag and a source-reading pre-hook.
The project declares its seed directory through the supported `data-paths`
alias so discovery must retain the seed as well as the source declaration.

The reporting model chooses its input from `JAFFLE_SETTLEMENT_INPUT`, defaulting
to all staging events. Set that variable to `positive_settlement_events` to
select only positive settlements. This makes an environment override observable
as a changed dependency without relying on warehouse state.

The expected native dbt 2 graph contains five models, one seed, one source and
two unconsumed functions. The original reconciliation model edges remain:

- `stg_settlement_events` → `settlement_gateway.raw_settlement_events`.
- `positive_settlement_events` → `stg_settlement_events`.
- `customer_settlement_totals` → `stg_settlement_events`.
- `customer_settlement_totals` → `settlement_gateway.raw_settlement_events`
  through the pre-hook.

With the environment override, only the reporting model's model dependency
changes from `stg_settlement_events` to `positive_settlement_events`.

The additional input audit decodes a JSON selection through a callable alias,
builds a validated model name from the staging relation's parse-time identifier,
and uses a helper's implicit varargs to count both validated and positive input
rows. It also resolves the gateway source identifier to the fixture seed.
The added dependencies are:

- `stg_settlement_events_validated` → `stg_settlement_events`.
- `settlement_input_audit` → `stg_settlement_events`.
- `settlement_input_audit` → `stg_settlement_events_validated`.
- `settlement_input_audit` → `positive_settlement_events`.
- `settlement_input_audit` → `settlement_gateway.raw_settlement_events`.
- `settlement_input_audit` → seed `raw_settlement_events`.

Together the isolated example has nine nodes and ten edges. Reading a
relation's parse-time identifier is native-family behavior; it is not a general
claim that Core relations expose a physical alias known from source alone.

A guarded staging diagnostic uses the older runtime's `PRINT` flag. Official
dbt 2.0.9 leaves that flag undefined, so the guard must not add a dependency on
`positive_settlement_events` in the default graph. Copying an older runtime's
flag defaults into native dbt 2 semantics would produce a false extra edge.

The seed and source identify the same physical table; a dbt source declaration
does not create an extra graph dependency on the seed.

The minimum-only dbt requirement exercises automatic family routing: among
supported dbt Core 1.x and native 2.x engines, `>=2.0.0` excludes Core without
requiring an artificial upper bound or a native version subprocess. It makes
no claim about a future dbt 3 engine.

Two proposed minor-unit currency conversion functions are intentionally
unconsumed. One is disabled by project configuration and one by inline config.
Official native 2.0.9 capability probes retain these definitions in active
manifest/list storage, while a consumer of a disabled function makes parse
fail. Their presence is a storage behavior, not permission to call them.
The examples carry argument and return declarations so the distinction is
executable without changing the existing reconciliation model dependencies.

For an isolated run, copy this directory to a temporary directory, copy
`profiles.example.yml` to `profiles.yml` there, and use an explicit official
dbt 2.0.9 executable:

```bash
/path/to/dbt-2.0.9 parse --project-dir . --profiles-dir . --no-partial-parse
/path/to/dbt-2.0.9 seed --project-dir . --profiles-dir .
/path/to/dbt-2.0.9 run --project-dir . --profiles-dir .
```

The public source reference is dbt 2.0.8 at
[`43918198c2f02366ceb33f60006812872b0bab40`](https://github.com/dbt-labs/dbt/blob/43918198c2f02366ceb33f60006812872b0bab40/crates/dbt-jinja-utils/src/phases/parse/resolve_model_context.rs#L101-L170),
which installs the same resolver objects under the top-level names and
`builtins`. That public tag is a source-audit reference; it is not the source
identity of the separately distributed 2.0.9 executable. Record native
behavior checks with the executable version separately from the public source
pin. Full seed/run validation has not yet been run for this fixture.
Earlier five-node/four-edge wrapper probes predate the namespace mutation and
disabled-function additions; they do not validate the current fixture bytes.
The later seven-node/four-edge receipt predates the JSON/varargs/input-audit
addition too. Native checks must record the new source fingerprint separately.
