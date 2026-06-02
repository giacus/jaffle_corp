#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${PROHIBITED_PATTERN:-}" ]]; then
  echo "Set PROHIBITED_PATTERN to a case-insensitive regex before publishing."
  exit 0
fi

matches="$(
  rg -n -i "${PROHIBITED_PATTERN}" . \
    --glob '!**/dbt_packages/**' \
    --glob '!**/target/**' \
    --glob '!**/logs/**' \
    --glob '!.venv/**' \
    --glob '!*.duckdb*' \
  | grep -vE 'PROHIBITED_PATTERN=.*scripts/check_sanitization[.]sh' || true
)"

if [[ -n "${matches}" ]]; then
  printf '%s\n' "${matches}"
  echo "Found prohibited terms."
  exit 1
fi

echo "No prohibited terms found."
