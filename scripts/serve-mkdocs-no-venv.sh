#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# Prefer pipx if available: keeps install isolated without venv
if command -v pipx >/dev/null 2>&1; then
  echo "Using pipx to install/run mkdocs (user-level, no venv)..."
  pipx install --force mkdocs mkdocs-material mkdocs-mermaid2-plugin || true
else
  echo "pipx not found. Will install mkdocs & plugins with pip --user (no venv)."
  python3 -m pip install --user --upgrade pip
  python3 -m pip install --user mkdocs mkdocs-material mkdocs-mermaid2-plugin
  # Make sure ~/.local/bin is in PATH for this shell session
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "Serving MkDocs on http://127.0.0.1:4000"
# bind to 127.0.0.1:4000 explicitly
mkdocs serve -a 127.0.0.1:4000
