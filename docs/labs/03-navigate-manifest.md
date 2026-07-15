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

## Checkpoint

You are done when you can locate a model's owner, source file, access, contract,
and graph links without searching the repository manually.

Continue to [Lab 4: Prove a test can fail](04-prove-test-failure.md).
