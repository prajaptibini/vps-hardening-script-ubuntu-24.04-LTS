#!/bin/bash
# Quick Start Script - Run this after reconnecting as prod-dokploy

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "=================================================================="
echo "  🚀 Dokploy VPS Setup - Quick Start"
echo "=================================================================="
echo ""

# Check if running as prod-dokploy
if [ "$(whoami)" != "prod-dokploy" ]; then
    echo "❌ Error: This script must be run as user 'prod-dokploy'"
    echo "Current user: $(whoami)"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "main_setup.sh" ]; then
    echo "❌ Error: main_setup.sh not found"
    echo "Please navigate to the installation directory first"
    exit 1
fi

echo "Starting main setup..."
echo ""

# Run main setup
./main_setup.sh

echo ""
echo "=================================================================="
echo "  ✅ Installation Complete!"
echo "=================================================================="
echo ""
echo "🎉 Dokploy is now installed and running!"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Access Dokploy web interface:"
echo "   http://$(curl -s ifconfig.me 2>/dev/null):3000"
echo ""
echo "2. Create your admin account"
echo ""
echo "3. Configure your domain and SSL certificate"
echo ""
echo "4. After SSL setup, secure port 3000:"
echo "   ./post_ssl_setup.sh"
echo ""
echo "5. Check system health:"
echo "   ./system_check.sh"
echo ""
echo "=================================================================="
echo ""
