#!/bin/bash
set -e

OPENWRT_SDK_PATH="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== UxPlay OpenWrt Build Helper ==="

# Verify SDK
if [ ! -f "$OPENWRT_SDK_PATH/rules.mk" ]; then
    echo "Error: Invalid OpenWrt SDK path"
    echo "Usage: $0 /path/to/openwrt-sdk"
    exit 1
fi

echo "SDK: $OPENWRT_SDK_PATH"
echo "Package: $SCRIPT_DIR"

# Copy package
PACKAGE_DIR="$OPENWRT_SDK_PATH/package/uxplay"
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR"
cp -r "$SCRIPT_DIR"/* "$PACKAGE_DIR/"
echo "✓ Package installed"

# Build
cd "$OPENWRT_SDK_PATH"
echo "Building..."
if make package/uxplay/compile V=s; then
    IPK_FILE=$(find bin/packages -name "uxplay_*.ipk" -type f | head -n 1)
    if [ -f "$IPK_FILE" ]; then
        echo "✓ Success: $IPK_FILE"
        echo ""
        echo "To install:"
        echo "  scp $IPK_FILE root@192.168.1.1:/tmp/"
        echo "  ssh root@192.168.1.1 'opkg install /tmp/$(basename $IPK_FILE)'"
    fi
else
    echo "✗ Build failed"
    exit 1
fi
