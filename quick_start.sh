#!/bin/bash
# Quick Start Script - Automated setup after user creation

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo "=================================================================="
echo "  🚀 VPS Hardening - Quick Start"
echo "=================================================================="
echo ""

# Read the username from the file created by create_user.sh
if [ -f "$HOME/.vps_setup_user" ]; then
    EXPECTED_USER=$(cat "$HOME/.vps_setup_user")
elif [ -f /tmp/new_user_name.txt ]; then
    EXPECTED_USER=$(cat /tmp/new_user_name.txt)
else
    echo -e "${YELLOW}⚠️  Could not determine expected user${NC}"
    echo "Current user: $(whoami)"
    read -p "Continue anyway? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
        exit 1
    fi
    EXPECTED_USER=$(whoami)
fi

# Check if running as the correct user
CURRENT_USER=$(whoami)
if [ "$CURRENT_USER" != "$EXPECTED_USER" ]; then
    echo -e "${RED}❌ Error: This script should be run as user '$EXPECTED_USER'${NC}"
    echo "Current user: $CURRENT_USER"
    echo ""
    read -p "Continue anyway? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
        exit 1
    fi
fi

# Check if we're in the right directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f "main_setup.sh" ]; then
    echo -e "${RED}❌ Error: main_setup.sh not found in current directory${NC}"
    echo "Current directory: $(pwd)"
    echo ""
    echo "Please navigate to: ~/vps-hardening-script-ubuntu-24.04-LTS"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found installation scripts"
echo ""

# Show menu
echo "What would you like to do?"
echo ""
echo "  1. Run full setup (recommended for new servers)"
echo "  2. Open interactive menu"
echo "  3. Exit"
echo ""
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "Starting full setup..."
        echo ""
        ./main_setup.sh
        ;;
    2)
        echo ""
        ./menu.sh
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

echo ""
echo "=================================================================="
echo "  ✅ Setup Complete!"
echo "=================================================================="
echo ""
echo "Next steps:"
echo "  • Access Dokploy: http://$(curl -s ifconfig.me 2>/dev/null):3000"
echo "  • After SSL setup: ./post_ssl_setup.sh"
echo "  • Check system: ./system_check.sh"
echo ""
echo "=================================================================="
echo ""
