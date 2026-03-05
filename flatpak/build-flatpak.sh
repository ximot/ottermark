#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ID="pl.ottersoft.ottermark"

echo "==> Building Flatpak from source..."
flatpak-builder --user --install --force-clean \
    "$SCRIPT_DIR/build-dir" \
    "$SCRIPT_DIR/$APP_ID.yml"

echo "==> Done! Run with: flatpak run $APP_ID"
