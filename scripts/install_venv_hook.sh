#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ACTIVATE_FILE="$ROOT_DIR/.venv/bin/activate"
HOOK_MARKER="# jaffle-corp env hook"

if [[ ! -f "$ACTIVATE_FILE" ]]; then
  echo "Could not find $ACTIVATE_FILE. Create the venv first with: python3.11 -m venv .venv" >&2
  exit 1
fi

if grep -qF "$HOOK_MARKER" "$ACTIVATE_FILE"; then
  tmp_file="$(mktemp)"
  awk -v marker="$HOOK_MARKER" '$0 == marker { exit } { print }' "$ACTIVATE_FILE" > "$tmp_file"
  cat "$tmp_file" > "$ACTIVATE_FILE"
  rm -f "$tmp_file"
fi

cat >> "$ACTIVATE_FILE" <<'HOOK'

# jaffle-corp env hook
if [ -n "${VIRTUAL_ENV:-}" ] && [ -f "$VIRTUAL_ENV/../scripts/env.sh" ]; then
    _JAFFLE_CORP_OLD_DBT_PROFILES_DIR="${DBT_PROFILES_DIR-}"
    _JAFFLE_CORP_OLD_DBT_PROFILES_DIR_SET="${DBT_PROFILES_DIR+x}"
    _JAFFLE_CORP_OLD_DUCKDB_PATH="${JAFFLE_CORP_DUCKDB_PATH-}"
    _JAFFLE_CORP_OLD_DUCKDB_PATH_SET="${JAFFLE_CORP_DUCKDB_PATH+x}"
    _JAFFLE_CORP_OLD_ROOT="${JAFFLE_CORP_ROOT-}"
    _JAFFLE_CORP_OLD_ROOT_SET="${JAFFLE_CORP_ROOT+x}"

    if [ -n "${BASH_VERSION:-}" ]; then
        eval "$(declare -f deactivate | sed '1s/deactivate/_jaffle_corp_original_deactivate/')"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        eval "$(functions deactivate | sed '1s/deactivate/_jaffle_corp_original_deactivate/')"
    fi

    deactivate() {
        _jaffle_corp_original_deactivate "$@"

        if [ "${_JAFFLE_CORP_OLD_DBT_PROFILES_DIR_SET:-}" = "x" ]; then
            export DBT_PROFILES_DIR="$_JAFFLE_CORP_OLD_DBT_PROFILES_DIR"
        else
            unset DBT_PROFILES_DIR
        fi

        if [ "${_JAFFLE_CORP_OLD_DUCKDB_PATH_SET:-}" = "x" ]; then
            export JAFFLE_CORP_DUCKDB_PATH="$_JAFFLE_CORP_OLD_DUCKDB_PATH"
        else
            unset JAFFLE_CORP_DUCKDB_PATH
        fi

        if [ "${_JAFFLE_CORP_OLD_ROOT_SET:-}" = "x" ]; then
            export JAFFLE_CORP_ROOT="$_JAFFLE_CORP_OLD_ROOT"
        else
            unset JAFFLE_CORP_ROOT
        fi

        unset -f _jaffle_corp_original_deactivate 2>/dev/null || true
        unset _JAFFLE_CORP_OLD_DBT_PROFILES_DIR
        unset _JAFFLE_CORP_OLD_DBT_PROFILES_DIR_SET
        unset _JAFFLE_CORP_OLD_DUCKDB_PATH
        unset _JAFFLE_CORP_OLD_DUCKDB_PATH_SET
        unset _JAFFLE_CORP_OLD_ROOT
        unset _JAFFLE_CORP_OLD_ROOT_SET
    }

    _JAFFLE_CORP_OLD_ENV_QUIET="${JAFFLE_CORP_ENV_QUIET-}"
    _JAFFLE_CORP_OLD_ENV_QUIET_SET="${JAFFLE_CORP_ENV_QUIET+x}"
    JAFFLE_CORP_ENV_QUIET=1
    . "$VIRTUAL_ENV/../scripts/env.sh"

    if [ "${_JAFFLE_CORP_OLD_ENV_QUIET_SET:-}" = "x" ]; then
        export JAFFLE_CORP_ENV_QUIET="$_JAFFLE_CORP_OLD_ENV_QUIET"
    else
        unset JAFFLE_CORP_ENV_QUIET
    fi
    unset _JAFFLE_CORP_OLD_ENV_QUIET
    unset _JAFFLE_CORP_OLD_ENV_QUIET_SET
fi
HOOK

echo "Installed jaffle-corp env hook in .venv/bin/activate"
