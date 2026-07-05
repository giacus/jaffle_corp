#!/usr/bin/env bash

if [ -n "${BASH_VERSION:-}" ] && [ "${BASH_SOURCE[0]}" = "$0" ]; then
  echo "Run this in your current shell: source scripts/env.sh" >&2
  exit 1
fi

if [ -n "${ZSH_VERSION:-}" ]; then
  case "${ZSH_EVAL_CONTEXT:-}" in
    *:file*) ;;
    *)
      echo "Run this in your current shell: source scripts/env.sh" >&2
      return 1 2>/dev/null || exit 1
      ;;
  esac
fi

if [ -n "${BASH_VERSION:-}" ]; then
  _jaffle_corp_env_file="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
  _jaffle_corp_env_file="${(%):-%N}"
else
  _jaffle_corp_env_file="$0"
fi

_jaffle_corp_root="$(cd "$(dirname "$_jaffle_corp_env_file")/.." && pwd -P)"
if [ ! -f "$_jaffle_corp_root/profiles.yml" ]; then
  echo "Could not find profiles.yml next to scripts/env.sh." >&2
  return 1 2>/dev/null || exit 1
fi

export JAFFLE_CORP_ROOT="$_jaffle_corp_root"
export DBT_PROFILES_DIR="$JAFFLE_CORP_ROOT"
export JAFFLE_CORP_DUCKDB_PATH="$JAFFLE_CORP_ROOT/jaffle_corp.duckdb"

if [ "${JAFFLE_CORP_ENV_QUIET:-0}" != "1" ]; then
  echo "JAFFLE_CORP_ROOT=$JAFFLE_CORP_ROOT"
  echo "DBT_PROFILES_DIR=$DBT_PROFILES_DIR"
  echo "JAFFLE_CORP_DUCKDB_PATH=$JAFFLE_CORP_DUCKDB_PATH"
fi

unset _jaffle_corp_env_file
unset _jaffle_corp_root
