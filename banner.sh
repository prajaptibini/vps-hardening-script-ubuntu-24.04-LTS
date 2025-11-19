#!/bin/bash
# Banner functions for pretty terminal output
# This file is meant to be sourced, not executed directly

# Prevent multiple sourcing
if [ -n "${BANNER_SH_LOADED}" ]; then
    return 0
fi
BANNER_SH_LOADED=1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Styles
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'

# Main installation banner
show_install_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                  VPS HARDENING & SECURITY SETUP                   ║
║                                                                   ║
║                Ubuntu 24.04 LTS + Dokploy Deploy                  ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${GRAY}Version 3.0.0 | Production Ready | MIT License${NC}"
    echo -e "${GRAY}https://github.com/alexandreravelli/vps-hardening-script-ubuntu-24.04-LTS${NC}"
    echo ""
}

# User creation banner
show_user_banner() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║                 🔐  SECURE USER CREATION  🔐                    ║
║                                                                  ║
║           Creating secure admin user with SSH keys               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Main setup banner
show_setup_banner() {
    clear
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                   🚀  MAIN SYSTEM SETUP  🚀                      ║
║                                                                   ║
║          Configuring security, firewall, and services             ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# SSL setup banner
show_ssl_banner() {
    clear
    echo -e "${MAGENTA}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                  🔒  POST-SSL SECURITY  🔒                       ║
║                                                                   ║
║         Hardening port 3000 after SSL configuration               ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# System check banner
show_check_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                 📊  SYSTEM HEALTH CHECK  📊                      ║
║                                                                   ║
║         Verifying system configuration and services               ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Success banner
show_success_banner() {
    echo ""
    echo -e "${GREEN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                       ✅  SUCCESS!  ✅                           ║
║                                                                   ║
║              Installation completed successfully!                 ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Error banner
show_error_banner() {
    echo ""
    echo -e "${RED}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                        ❌  ERROR!  ❌                            ║
║                                                                   ║
║              Something went wrong during setup                    ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Progress bar
show_progress() {
    local current=$1
    local total=$2
    local message=$3
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    echo -ne "\r${CYAN}["
    printf "%${completed}s" | tr ' ' '█'
    printf "%${remaining}s" | tr ' ' '░'
    echo -ne "]${NC} ${percentage}% - ${message}"
    
    if [ $current -eq $total ]; then
        echo ""
    fi
}

# Section header
show_section() {
    local title=$1
    echo ""
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${WHITE}  $title${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Info box
show_info_box() {
    local title=$1
    shift
    local lines=("$@")
    
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${BOLD}${WHITE}${title}${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    for line in "${lines[@]}"; do
        echo -e "${CYAN}║${NC} ${line}"
    done
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Warning box
show_warning_box() {
    local title=$1
    shift
    local lines=("$@")
    
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC} ${BOLD}${YELLOW}⚠️  ${title}${NC}"
    echo -e "${YELLOW}╠═══════════════════════════════════════════════════════════════╣${NC}"
    for line in "${lines[@]}"; do
        echo -e "${YELLOW}║${NC} ${line}"
    done
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Spinner animation
show_spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %10 ))
        printf "\r${CYAN}${spin:$i:1}${NC} ${message}..."
        sleep 0.1
    done
    printf "\r${GREEN}✓${NC} ${message}... Done!\n"
}

# --- Utility Functions ---

# Check if running as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}Error: This script requires sudo privileges.${NC}"
        echo "Please run with: sudo $0"
        exit 1
    fi
}

# Standardized logging
log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check command existence
check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "Command '$1' not found. Please install it."
        return 1
    fi
    return 0
}
