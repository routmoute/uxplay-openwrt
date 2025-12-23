#!/bin/sh
# Installation script to setup config and install services

echo "=== Installing UxPlay on OpenWrt ===" 

# Copy init script
if [ -d "/etc/init.d" ]; then
    echo "Installing startup script..."
    cp uxplay.init /etc/init.d/uxplay
    chmod +x /etc/init.d/uxplay
fi

# Copy UCI configuration
if [ -d "/etc/config" ]; then
    echo "Installing configuration..."
    cp etc_config_uxplay /etc/config/uxplay
fi

# Enable service
if command -v /etc/init.d/uxplay &> /dev/null; then
    echo "Enabling service at startup..."
    /etc/init.d/uxplay enable
fi

echo "=== Installation complete ===" 
echo ""
echo "To start the service:"
echo "  /etc/init.d/uxplay start"
echo ""
echo "To check status:"
echo "  /etc/init.d/uxplay status"
echo ""
echo "To view logs:"
