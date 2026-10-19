# dbt 2 semantic graph fixture

This compact fixture is intentionally outside `projects/`: the maintained Jaffle
projects require dbt 1.11.12, while this case exercises the model-attached
semantic and metric contract introduced by official dbt 2.0.6.

The model uses the qualified source literal
`source('legacy.settlement_gateway', 'settlement_events')`, resolved from the local dependency project named `legacy`. Its attached
semantic model defines the event entities and dimensions; simple metrics stay
with the model, while ratio, derived, cumulative, and conversion metrics are
declared in `models/metrics.yml`. `scripts/verify_dbt2_semantic_graph.py`
parses the fixture with an explicit dbt 2 executable and checks exact manifest
dependency IDs plus negative controls for source resolution, disabled
resources, omitted semantic fields, and duplicate dotted source names.

Run the isolated verifier from the repository root with the pinned executable:

```bash
python scripts/verify_dbt2_semantic_graph.py \
  --dbt /path/to/dbt-2.0.6 \
  --output /tmp/dbt2-semantic-graph.json
```
