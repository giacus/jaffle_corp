## Summary

-

## Validation

- `scripts/validate_local.sh` result (obtain consent before an agent starts a run
  expected to exceed five minutes):
- Exact focused commands and outcomes:
- Reused evidence, unchanged scope, and checks not rerun:

## Safety Checks

- [ ] I did not add real company, customer, vendor, employee, warehouse, schema, or private system data.
- [ ] Public model contract changes reported by `scripts/report_public_contract_changes.py` are intentional and documented.

Local policy checks reject tracked generated artifacts, dependency-lock drift,
invalid Taskfile commands, and non-public cross-project model dependencies.
The optional manual Actions job checks only workflow trigger policy.

## Notes

-
