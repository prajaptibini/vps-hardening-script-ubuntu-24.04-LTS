#!/bin/bash
# SCRIPT: System Health Check - Operational Status
# Verifies: Load, RAM, Disk, Time, DNS, Services, Docker

set -e

# Load banner functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/banner.sh" ]; then
    source "$SCRIPT_DIR/banner.sh"
else
    # Fallback
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m'
    
    show_section() { echo -e "${BLUE}--- $1 ---${NC}"; }
    report_finding() { echo "$1: $2"; }
fi

# Initialize counters
ISSUES=0
WARNINGS=0
OK=0

# Function to report findings
report_status() {
    local status=$1
    local message=$2
    local detail=$3
    
    case $status in
        OK)
            echo -e "${GREEN}[OK]${NC} $message"
            OK=$((OK + 1))
            ;;
        WARN)
            echo -e "${YELLOW}[WARN]${NC} $message"
            WARNINGS=$((WARNINGS + 1))
            ;;
        FAIL)
            echo -e "${RED}[FAIL]${NC} $message"
            ISSUES=$((ISSUES + 1))
            ;;
        INFO)
            echo -e "${CYAN}[INFO]${NC} $message"
            ;;
    esac
    
    if [ -n "$detail" ]; then
        echo "  → $detail"
    fi
}

clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                 📊  SYSTEM HEALTH REPORT  📊                     ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo ""

# 1. System Resources
show_section "System Resources"

# Load Average
LOAD=$(cat /proc/loadavg | awk '{print $1}')
CORES=$(nproc)
echo "  Load Average (1m): $LOAD (Cores: $CORES)"
if (( $(echo "$LOAD < $CORES" | bc -l) )); then
    report_status "OK" "System load is normal"
else
    report_status "WARN" "System load is high" "Load $LOAD > Cores $CORES"
fi

# Memory
MEM_USED=$(free -m | awk 'NR==2{print $3}')
MEM_TOTAL=$(free -m | awk 'NR==2{print $2}')
MEM_PERCENT=$((MEM_USED * 100 / MEM_TOTAL))
echo "  Memory: ${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PERCENT}%)"

if [ "$MEM_PERCENT" -lt 80 ]; then
    report_status "OK" "Memory usage is healthy"
elif [ "$MEM_PERCENT" -lt 90 ]; then
    report_status "WARN" "Memory usage is high"
else
    report_status "FAIL" "Memory usage is critical"
fi

# Disk
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo "  Disk (/): ${DISK_USAGE}% used"

if [ "$DISK_USAGE" -lt 70 ]; then
    report_status "OK" "Disk space is healthy"
elif [ "$DISK_USAGE" -lt 90 ]; then
    report_status "WARN" "Disk space is getting low"
else
    report_status "FAIL" "Disk space is critical"
fi

# 2. Time Synchronization
show_section "Time Synchronization"

if command -v timedatectl &> /dev/null; then
    if timedatectl status | grep -q "System clock synchronized: yes"; then
        report_status "OK" "System clock is synchronized"
    else
        report_status "FAIL" "System clock is NOT synchronized" "Check NTP service"
    fi
else
    report_status "WARN" "timedatectl not found"
fi

# 3. Network & DNS
show_section "Network & DNS"

# Public IP
IPV4=$(curl -4 -s --max-time 2 ifconfig.me 2>/dev/null || echo "Unknown")
echo "  Public IPv4: $IPV4"

# DNS Check (Quad9)
if resolvectl status | grep -q "9.9.9.11"; then
    report_status "OK" "Using Quad9 DNS"
else
    report_status "WARN" "Not using Quad9 DNS" "Check 'resolvectl status'"
fi

# Connectivity
if ping -c 1 -W 2 9.9.9.9 &> /dev/null; then
    report_status "OK" "Internet connectivity confirmed"
else
    report_status "FAIL" "No internet connectivity"
fi

# 4. Services
show_section "Critical Services"

check_service() {
    if systemctl is-active --quiet "$1"; then
        report_status "OK" "Service '$1' is running"
    else
        report_status "FAIL" "Service '$1' is NOT running"
    fi
}

check_service "ssh"
check_service "fail2ban"
check_service "docker"

# 5. Docker Health
show_section "Docker Health"

if command -v docker &> /dev/null; then
    CONTAINER_COUNT=$(docker ps -q | wc -l)
    echo "  Running Containers: $CONTAINER_COUNT"
    
    if docker ps | grep -q dokploy; then
        report_status "OK" "Dokploy container is running"
        
        # Check Port 3000 response
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null || echo "000")
        if [[ "$HTTP_CODE" =~ ^(200|301|302)$ ]]; then
            report_status "OK" "Dokploy is responding (HTTP $HTTP_CODE)"
        else
            report_status "WARN" "Dokploy not responding (HTTP $HTTP_CODE)"
        fi
    else
        report_status "FAIL" "Dokploy container not found"
    fi
else
    report_status "FAIL" "Docker not installed"
fi

# Summary
echo ""
echo "=================================================================="
echo "  📊 HEALTH SUMMARY"
echo "=================================================================="
echo -e "${GREEN}OK:       $OK${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "${RED}Issues:   $ISSUES${NC}"
echo ""

if [ $ISSUES -gt 0 ]; then
    echo -e "${RED}❌ System has critical issues.${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  System has warnings.${NC}"
    exit 0
else
    echo -e "${GREEN}✅ System is healthy!${NC}"
    exit 0
fi