#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# Create venv if it doesn't exist
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi

source .venv/bin/activate
pip install --upgrade pip
pip install mkdocs mkdocs-material mkdocs-mermaid2-plugin

echo "Serving MkDocs on http://127.0.0.1:8000"
mkdocs serve
