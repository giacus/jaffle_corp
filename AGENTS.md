# Repository Agent Instructions

Read `/Users/giacomoleo/Projects/PROJECT_OPERATING_MODEL.md` and the private
project catalog before changing this repository.

- Keep the fixture fictional, compact, deterministic, laptop-runnable, and
  independent from any consumer implementation.
- Run `scripts/validate_local.sh` before pushing a branch or pull request and
  record the result in the PR validation summary.
- GitHub Actions must use `workflow_dispatch` only. Keep dbt, MetricFlow,
  documentation, manifest, and repository validation local; the remote manual
  job is only a dependency-free trigger-policy safeguard.
- Do not run validation expected to exceed five minutes without first warning
  the owner and receiving explicit consent. Reuse still-valid evidence when
  the fixture surface under that expensive gate is unchanged, and record that
  the gate was not rerun.
