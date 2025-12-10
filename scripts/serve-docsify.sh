#!/usr/bin/env bash
set -euo pipefail

# Serve docsify on port 4000. If docs/index.html doesn't exist, init docsify.
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [ ! -f "docs/index.html" ]; then
  echo "docs/index.html not found — initializing docsify..."
  npx docsify-cli@4 init docs --force
fi

echo "Serving docs with docsify on http://localhost:4000"
npx docsify-cli@4 serve docs -p 4000
