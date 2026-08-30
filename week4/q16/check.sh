#!/usr/bin/env bash
set -euo pipefail

echo "=== ruff format --check ==="
ruff format --check .

echo "=== ruff check ==="
ruff check .

echo "=== pytest ==="
python -m pytest test_cli.py -v

echo "=== All checks passed ==="
