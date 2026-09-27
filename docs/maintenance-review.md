# Maintenance and dependency review

Reviewed against `master` commit `65cd46a0bfce28bc3c44dfc20e24d2d2a25bdfe5`.
These decisions apply to the exact PR heads below; reassess them after a rebase
or a coordinated runtime upgrade. No dependency update is included here.

## Dependency decisions

| PR and reviewed head | Decision | Evidence and next action |
| --- | --- | --- |
| [#27](https://github.com/giacus/jaffle_corp/pull/27), `00d75b2` | Do not merge with the current stack | `dbt-core==1.11.12` requires `dbt-semantic-interfaces>=0.9.0,<0.10`; the proposed `0.10.5` makes pip resolution fail. Close as incompatible, or replace with a coordinated dbt/MetricFlow upgrade. |
| [#28](https://github.com/giacus/jaffle_corp/pull/28), `876b0df` | Compatible in focused checks; full fixture validation pending | The proposed `regex==2026.7.19` resolves and installs with the complete lock in a clean Python 3.11 environment; `pip check` passes. SQLFluff is its only declared consumer in this stack. Complete the local gate before merging. |
| [#29](https://github.com/giacus/jaffle_corp/pull/29), `801d238` | Do not merge with the current stack | `dbt-common==1.38.0` requires `deepdiff>=7.0,<9.0`; the proposed `9.1.0` makes pip resolution fail. Close as incompatible, or replace alongside a compatible dbt-common/dbt-core stack. |
| [#30](https://github.com/giacus/jaffle_corp/pull/30), `9007a92` | Obsolete | All four changed `actions/setup-python` steps were removed from current `master`. Close the stale conflicting PR. Do not restore the old automatic workflow to resolve its conflict. |

These are recommendations, not PR closures or merge approvals. Old hosted
checks apply to old PR bases and do not establish current fixture compatibility.

## Reproducible checks

For each Python PR, apply only its one-line lockfile change to the reviewed
current base, then run this in a disposable Python 3.11 environment:

```bash
python -m pip install --dry-run -r requirements.lock.txt
```

The #27 and #29 candidates fail with `ResolutionImpossible` and the exact upper
bounds above. No runtime test is needed to demonstrate their installation
failure. Do not bypass the resolver with `--no-deps` to accept either update.

For #28, installation of the complete candidate lock succeeds in a fresh venv:

```bash
python -m pip install -r requirements.lock.txt
python -m pip check
python -m unittest discover -s tests -p 'test_*.py' -v
```

A focused SQLFluff comparison parsed all 203 authored SQL sources with each
regex version using the DuckDB dialect and raw templater. The parsed raw tree
text and diagnostic code, position, and description matched for every file.
Raw Jinja diagnostics are expected in this comparison; this is not a successful
dbt compilation or full SQL lint claim. All 17 repository tests passed in the candidate environment, including real dbt
snapshot parsing and the SQLFluff snapshot adapter.

The full dbt builds, MetricFlow queries, and documentation gate have not been
rerun with #28. Run `scripts/validate_local.sh` on its updated branch before
merging, after obtaining consent for a run expected to exceed five minutes.

## Environment and documentation maintenance

The canonical checkout was fast-forwarded to the reviewed `master` before this
work. Its existing `.venv` has drift: `pathspec==1.1.1` conflicts with dbt's
bounds, while the lock pins `pathspec==0.12.1`. An extra installed
`black==26.5.1` requires `pathspec>=1.0.0`, so merely downgrading pathspec cannot
make that shared environment consistent. The clean candidate environment has
no such conflict. Recreate the fixture venv from the lock before the next full
run; keep unrelated tooling outside it and preserve database/artifact state.

README, contributor instructions, getting-started automation notes, and the PR
template now describe local validation and the optional manual policy check
consistently. No GitHub settings were changed. The branch-protection API reports
`required_status_checks: null` for `master`; the removed automatic `validate`
check is not required there.

For this documentation-only change, prior full-gate evidence is the recorded
`scripts/validate_local.sh` pass in
[PR #43](https://github.com/giacus/jaffle_corp/pull/43) at `cd8fad1`.
Its Git tree is identical to the reviewed base (`65d45d827a782702c9b1d53a550c52076aa402e1`).
The original raw log is no longer available at its recorded local path, so this
is explicitly reused PR-attested evidence, not a freshly observed full pass.
Fresh static checks and repository tests are recorded in this change's PR.
This evidence does not validate the #28 dependency change.
