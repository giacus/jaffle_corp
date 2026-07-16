# Lab 3: Navigate the Full Manifest

[Labs](../labs.md) · Previous: [Trace recognized revenue](02-trace-revenue.md) · Next: [Prove a test can fail](04-prove-test-failure.md)

## At a Glance

- **Level:** guided
- **Time:** 20–30 minutes
- **Requires:** the local environment from Lab 1
- **You will:** use one dbt artifact as an index to the full repository.

## Generate the Artifact

```bash
scripts/generate_manifest.sh
```

The output is `target/manifest.json`.

## Explore

Use it to answer:

1. Which packages contain executable nodes?
2. How many public models does each package expose?
3. Which public models enforce contracts?
4. What are the parents and children of `fct_store_day_reliability`?
5. Which `original_file_path` defines `fct_order_revenue`?

With `jq`:

```bash
jq -r '
  .nodes
  | to_entries[]
  | select(.value.resource_type == "model" and .value.config.access == "public")
  | [.value.package_name, .value.name, .value.config.contract.enforced]
  | @tsv
' target/manifest.json
```

Without `jq`:

```bash
python - <<'PY'
import json
from pathlib import Path

manifest = json.loads(Path("target/manifest.json").read_text())
print(*sorted({node["package_name"] for node in manifest["nodes"].values()}), sep="\n")
PY
```

## Expected Observations

- The manifest combines resources from every installed project into one
  machine-readable catalog.
- `package_name`, `original_file_path`, access, contract configuration, and
  dependency identifiers let you move between ownership, code, and lineage.
- Public interfaces are a subset of all executable nodes; ephemeral and
  protected models still appear in the artifact.

## Common Failure Modes

If `target/manifest.json` is missing or does not reflect recent edits, rerun
`scripts/generate_manifest.sh`. If `jq` is unavailable, use the Python example;
the learning objective is the artifact structure, not a particular CLI tool.

## Workspace State and Cleanup

The generated root `target/manifest.json` and per-project package/target folders
are ignored build artifacts. Keep the manifest while exploring the later labs,
or remove all local workshop state with `scripts/clean.sh`.

## Completion Rubric

- [ ] You can locate a model's owner and source file from the manifest.
- [ ] You can distinguish public contracted models from internal graph nodes.
- [ ] You can recover the parents and children of a named model from artifact
      identifiers without manually searching SQL files.
- [ ] Your answers come from a freshly generated manifest.

Continue to [Lab 4: Prove a test can fail](04-prove-test-failure.md).
