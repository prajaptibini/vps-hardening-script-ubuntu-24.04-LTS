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

# Standardized logging with timestamps
log_info() {
    echo -e "${CYAN}ℹ${NC}  $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_step() {
    echo -e "${BLUE}→${NC} $1"
}

# Check command existence
check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "Command '$1' not found. Please install it."
        return 1
    fi
    return 0
}

# Validation box - show validation results
show_validation_box() {
    local title="$1"
    shift
    local items=("$@")
    
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} ${BOLD}${WHITE}✓ ${title}${NC}"
    echo -e "${BLUE}╠═══════════════════════════════════════════════════════════════╣${NC}"
    for item in "${items[@]}"; do
        echo -e "${BLUE}║${NC} ${item}"
    done
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Error box - show errors with context
show_error_box() {
    local title="$1"
    shift
    local items=("$@")
    
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${BOLD}${RED}✗ ${title}${NC}"
    echo -e "${RED}╠═══════════════════════════════════════════════════════════════╣${NC}"
    for item in "${items[@]}"; do
        echo -e "${RED}║${NC} ${item}"
    done
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Step header - consistent formatting for each major step
show_step_header() {
    local step_num="$1"
    local total_steps="$2"
    local title="$3"
    
    echo ""
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${CYAN}  Step ${step_num}/${total_steps}: ${title}${NC}"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Validation checkpoint - verify before proceeding
validation_checkpoint() {
    local check_name="$1"
    local check_command="$2"
    local success_msg="$3"
    local error_msg="$4"
    
    log_step "Validating: $check_name..."
    
    if eval "$check_command" &>/dev/null; then
        log_success "$success_msg"
        return 0
    else
        log_error "$error_msg"
        return 1
    fi
}

# Spacer - visual breathing room
spacer() {
    echo ""
}

# Divider - section separator
divider() {
    echo -e "${GRAY}────────────────────────────────────────────────────────────────${NC}"
}

# Modern progress bar with percentage and ETA
show_modern_progress() {
    local current=$1
    local total=$2
    local message=$3
    local start_time=${4:-0}
    
    local percentage=$((current * 100 / total))
    local bar_width=50
    local filled=$((bar_width * current / total))
    local empty=$((bar_width - filled))
    
    # Calculate ETA
    local eta_msg=""
    if [ "$start_time" -gt 0 ] && [ "$current" -gt 0 ]; then
        local elapsed=$(($(date +%s) - start_time))
        local rate=$((elapsed / current))
        local remaining=$((total - current))
        local eta=$((rate * remaining))
        
        if [ "$eta" -gt 60 ]; then
            eta_msg="~$((eta / 60))m remaining"
        else
            eta_msg="~${eta}s remaining"
        fi
    fi
    
    # Build progress bar
    printf "\r${CYAN}["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "]${NC} ${BOLD}%3d%%${NC} - %s" "$percentage" "$message"
    
    if [ -n "$eta_msg" ]; then
        printf " ${GRAY}($eta_msg)${NC}"
    fi
    
    # New line if complete
    if [ "$current" -eq "$total" ]; then
        echo ""
    fi
}

# Installation dashboard - show complete status
show_installation_dashboard() {
    local ssh_port="$1"
    local public_ip="$2"
    local new_user="$3"
    
    clear
    echo ""
    echo -e "${GREEN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                  🎉  INSTALLATION COMPLETE!  🎉                  ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # Services Status
    echo -e "${BOLD}${CYAN}━━━ Services Status ━━━${NC}"
    echo ""
    
    # SSH Status
    if systemctl is-active --quiet ssh; then
        echo -e "  ${GREEN}✓${NC} SSH:      ${GREEN}Running${NC} on port ${CYAN}$ssh_port${NC}"
    else
        echo -e "  ${RED}✗${NC} SSH:      ${RED}Not running${NC}"
    fi
    
    # UFW Status
    if sudo ufw status | grep -q "Status: active"; then
        local rule_count=$(sudo ufw status numbered | grep -c "\[" || echo "0")
        echo -e "  ${GREEN}✓${NC} UFW:      ${GREEN}Active${NC} (${rule_count} rules)"
    else
        echo -e "  ${YELLOW}⚠${NC}  UFW:      ${YELLOW}Inactive${NC}"
    fi
    
    # Docker Status
    if systemctl is-active --quiet docker; then
        local container_count=$(docker ps -q | wc -l)
        echo -e "  ${GREEN}✓${NC} Docker:   ${GREEN}Running${NC} (${container_count} container(s))"
    else
        echo -e "  ${RED}✗${NC} Docker:   ${RED}Not running${NC}"
    fi
    
    # Dokploy Status
    if docker ps | grep -q dokploy; then
        echo -e "  ${GREEN}✓${NC} Dokploy:  ${GREEN}Ready${NC} at ${CYAN}http://$public_ip:3000${NC}"
    else
        echo -e "  ${YELLOW}⚠${NC}  Dokploy:  ${YELLOW}Not found${NC}"
    fi
    
    # Fail2Ban Status
    if systemctl is-active --quiet fail2ban; then
        echo -e "  ${GREEN}✓${NC} Fail2Ban: ${GREEN}Monitoring SSH${NC}"
    else
        echo -e "  ${YELLOW}⚠${NC}  Fail2Ban: ${YELLOW}Not running${NC}"
    fi
    
    echo ""
    echo -e "${BOLD}${CYAN}━━━ Quick Start ━━━${NC}"
    echo ""
    echo -e "  ${BOLD}1.${NC} Access Dokploy:"
    echo -e "     ${CYAN}http://$public_ip:3000${NC}"
    echo ""
    echo -e "  ${BOLD}2.${NC} Create your admin account"
    echo ""
    echo -e "  ${BOLD}3.${NC} Configure your first domain"
    echo ""
    echo -e "  ${BOLD}4.${NC} After SSL setup, secure port 3000:"
    echo -e "     ${CYAN}./post_ssl_setup.sh${NC}"
    echo ""
    echo -e "${BOLD}${CYAN}━━━ Documentation ━━━${NC}"
    echo ""
    echo -e "  ${GRAY}•${NC} Full docs:        ${CYAN}cat README.md${NC}"
    echo -e "  ${GRAY}•${NC} Security guide:   ${CYAN}cat SECURITY.md${NC}"
    echo -e "  ${GRAY}•${NC} Health check:     ${CYAN}./system_check.sh${NC}"
    echo -e "  ${GRAY}•${NC} Security audit:   ${CYAN}./security_audit.sh${NC}"
    echo ""
    echo -e "${BOLD}${CYAN}━━━ Connection Info ━━━${NC}"
    echo ""
    echo -e "  SSH Command: ${CYAN}ssh $new_user@$public_ip -p $ssh_port${NC}"
    echo -e "  SSH Port:    ${CYAN}$ssh_port${NC}"
    echo -e "  User:        ${CYAN}$new_user${NC}"
    echo ""
    echo -e "${GRAY}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GRAY}║${NC} ${YELLOW}⚠${NC}  ${BOLD}Important:${NC} Port 22 is now ${RED}DISABLED${NC}. Use port ${CYAN}$ssh_port${NC} only! ${GRAY}║${NC}"
    echo -e "${GRAY}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Summary box - show what will be done
show_installation_summary() {
    local ssh_port="$1"
    
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${BOLD}${WHITE}📋 INSTALLATION PLAN${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 1:${NC} System Update                    ${GRAY}[~2 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 2:${NC} Security Tools (UFW, Fail2Ban)   ${GRAY}[~1 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 3:${NC} Firewall Configuration           ${GRAY}[~1 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 4:${NC} Secure DNS (Quad9)               ${GRAY}[~1 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 5:${NC} SSH Port Change → ${CYAN}$ssh_port${NC}        ${GRAY}[~1 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 6:${NC} Fail2Ban Configuration           ${GRAY}[~1 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 7:${NC} Automatic Updates                ${GRAY}[~1 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 8:${NC} Docker Installation              ${GRAY}[~3 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 9:${NC} Docker Configuration             ${GRAY}[~1 min]${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Step 10:${NC} Dokploy Installation            ${GRAY}[~2 min]${NC}"
    echo -e "${CYAN}║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Total estimated time:${NC} ${GREEN}~15 minutes${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Disk space required:${NC} ${GREEN}~2 GB${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Network required:${NC}    ${GREEN}Active internet connection${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}
