#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"

scripts/bootstrap.sh
# shellcheck disable=SC1091
source .venv/bin/activate

python scripts/check_actions_policy.py
python scripts/check_markdown.py
python scripts/check_yaml.py
python scripts/check_semantic_models.py
python scripts/check_repo_policy.py
python -m unittest discover -s tests -p 'test_*.py' -v
bash -n scripts/*.sh
python -m py_compile scripts/*.py

scripts/validate_repo.sh
scripts/docs.sh generate

echo "Local validation passed. Canonical oracle: target/manifest.json"
