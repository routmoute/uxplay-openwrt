#!/bin/bash
# Helper script to compile UxPlay package for OpenWrt

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
OPENWRT_SDK_PATH="${1:-.}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -e "${GREEN}=== UxPlay OpenWrt Compilation Helper ===${NC}"
echo ""

# Verify OpenWrt SDK exists
if [ ! -f "$OPENWRT_SDK_PATH/rules.mk" ]; then
    echo -e "${RED}Error: OpenWrt SDK path is not valid.${NC}"
    echo "Usage: $0 /path/to/openwrt-sdk"
    exit 1
fi

echo -e "${YELLOW}Configuration detected:${NC}"
echo "OpenWrt SDK: $OPENWRT_SDK_PATH"
echo "UxPlay Package: $SCRIPT_DIR"
echo ""

# Check dependencies
echo -e "${YELLOW}Checking dependencies...${NC}"

MISSING_DEPS=0

if ! command -v make &> /dev/null; then
    echo -e "${RED}✗ make is not installed${NC}"
    MISSING_DEPS=1
fi

if ! command -v gcc &> /dev/null; then
    echo -e "${RED}✗ gcc is not installed${NC}"
    MISSING_DEPS=1
fi

if [ $MISSING_DEPS -eq 1 ]; then
    echo -e "${RED}Please install missing dependencies.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Dependencies OK${NC}"
echo ""

# Install package in SDK
echo -e "${YELLOW}Installing package in SDK...${NC}"

PACKAGES_DIR="$OPENWRT_SDK_PATH/feeds/packages"
if [ ! -d "$PACKAGES_DIR" ]; then
    mkdir -p "$PACKAGES_DIR"
fi

MULTIMEDIA_DIR="$PACKAGES_DIR/multimedia"
if [ ! -d "$MULTIMEDIA_DIR" ]; then
    mkdir -p "$MULTIMEDIA_DIR"
fi

# Create symlink or copy
if [ -L "$MULTIMEDIA_DIR/uxplay" ]; then
    rm "$MULTIMEDIA_DIR/uxplay"
fi

if [ -d "$MULTIMEDIA_DIR/uxplay" ]; then
    echo -e "${YELLOW}Existing uxplay directory, removing...${NC}"
    rm -rf "$MULTIMEDIA_DIR/uxplay"
fi

ln -s "$SCRIPT_DIR" "$MULTIMEDIA_DIR/uxplay"
echo -e "${GREEN}✓ Package installed in SDK${NC}"
echo ""

# Change to SDK directory
cd "$OPENWRT_SDK_PATH"

# Update feeds
echo -e "${YELLOW}Updating feeds...${NC}"
./scripts/feeds update packages &>/dev/null || true
./scripts/feeds install -a &>/dev/null || true
echo -e "${GREEN}✓ Feeds updated${NC}"
echo ""

# Compile
echo -e "${YELLOW}Compiling UxPlay package...${NC}"
echo "Command: make package/uxplay/compile V=s"
echo ""

if make package/uxplay/compile V=s; then
    echo ""
    echo -e "${GREEN}✓ Compilation successful!${NC}"
    echo ""
    
    # Show .ipk file path
    IPK_FILE=$(find . -name "uxplay_*.ipk" -type f | head -n 1)
    if [ -f "$IPK_FILE" ]; then
        echo -e "${GREEN}Compiled package:${NC}"
        echo "$IPK_FILE"
        echo ""
        echo -e "${YELLOW}To install on router:${NC}"
        echo "scp $IPK_FILE root@192.168.1.1:/tmp/"
        echo "ssh root@192.168.1.1"
        echo "opkg install /tmp/$(basename $IPK_FILE)"
    fi
else
    echo ""
    echo -e "${RED}✗ Compilation error${NC}"
    echo "For more details, run:"
    echo "cd $OPENWRT_SDK_PATH && make package/uxplay/compile V=s"
    exit 1
fi
