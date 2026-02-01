#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
STAGING_DIR="$SCRIPT_DIR/build-staging"
APP_ID="pl.ottersoft.ottermark"
BINARY_NAME="ottermark"

echo "==> Building Tauri app..."
cd "$PROJECT_DIR"
bun run tauri build

BINARY_PATH="$PROJECT_DIR/src-tauri/target/release/$BINARY_NAME"
if [[ ! -f "$BINARY_PATH" ]]; then
    echo "ERROR: Binary not found at $BINARY_PATH"
    exit 1
fi

echo "==> Preparing staging directory..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR/icons"

cp "$BINARY_PATH" "$STAGING_DIR/$BINARY_NAME"
cp "$SCRIPT_DIR/$APP_ID.desktop" "$STAGING_DIR/"
cp "$SCRIPT_DIR/$APP_ID.metainfo.xml" "$STAGING_DIR/"
cp "$PROJECT_DIR/src-tauri/icons/32x32.png" "$STAGING_DIR/icons/"
cp "$PROJECT_DIR/src-tauri/icons/128x128.png" "$STAGING_DIR/icons/"
cp "$PROJECT_DIR/src-tauri/icons/128x128@2x.png" "$STAGING_DIR/icons/"
cp "$PROJECT_DIR/src-tauri/icons/icon.png" "$STAGING_DIR/icons/"

echo "==> Building Flatpak..."
flatpak-builder --user --install --force-clean \
    "$SCRIPT_DIR/build-dir" \
    "$SCRIPT_DIR/$APP_ID.yml"

echo "==> Done! Run with: flatpak run $APP_ID"
