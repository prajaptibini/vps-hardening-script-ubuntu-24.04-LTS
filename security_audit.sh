#!/bin/bash
# Security Audit Script - Comprehensive Security Check

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
echo "  🔒 VPS Security Audit"
echo "=================================================================="
echo ""

CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0

# Function to report findings
report_finding() {
    local severity=$1
    local title=$2
    local description=$3
    
    case $severity in
        CRITICAL)
            echo -e "${RED}[CRITICAL]${NC} $title"
            CRITICAL=$((CRITICAL + 1))
            ;;
        HIGH)
            echo -e "${RED}[HIGH]${NC} $title"
            HIGH=$((HIGH + 1))
            ;;
        MEDIUM)
            echo -e "${YELLOW}[MEDIUM]${NC} $title"
            MEDIUM=$((MEDIUM + 1))
            ;;
        LOW)
            echo -e "${CYAN}[LOW]${NC} $title"
            LOW=$((LOW + 1))
            ;;
        PASS)
            echo -e "${GREEN}[PASS]${NC} $title"
            ;;
    esac
    
    if [ -n "$description" ]; then
        echo "  → $description"
    fi
    echo ""
}

# 1. SSH Configuration Audit
echo -e "${BLUE}━━━ SSH Security ━━━${NC}"
echo ""

# Check SSH port
SSH_PORT=$(grep "^Port" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' || echo "22")
if [ "$SSH_PORT" = "22" ]; then
    report_finding "HIGH" "SSH on default port 22" "Change to non-standard port (50000-59999)"
else
    report_finding "PASS" "SSH on non-standard port: $SSH_PORT"
fi

# Check root login
if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config 2>/dev/null; then
    report_finding "CRITICAL" "Root login enabled" "Set 'PermitRootLogin no' in /etc/ssh/sshd_config"
elif grep -q "^PermitRootLogin no" /etc/ssh/sshd_config 2>/dev/null; then
    report_finding "PASS" "Root login disabled"
else
    report_finding "MEDIUM" "Root login setting unclear" "Explicitly set 'PermitRootLogin no'"
fi

# Check password authentication
if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
    report_finding "MEDIUM" "Password authentication enabled" "Consider using SSH keys only"
else
    report_finding "PASS" "Password authentication disabled or not explicitly enabled"
fi

# Check SSH key authentication
if grep -q "^PubkeyAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
    report_finding "PASS" "SSH key authentication enabled"
else
    report_finding "HIGH" "SSH key authentication not explicitly enabled" "Set 'PubkeyAuthentication yes'"
fi

# 2. Firewall Configuration
echo -e "${BLUE}━━━ Firewall Security ━━━${NC}"
echo ""

if command -v ufw &> /dev/null; then
    if sudo ufw status | grep -q "Status: active"; then
        report_finding "PASS" "UFW firewall is active"
        
        # Check if default SSH port is blocked
        if sudo ufw status | grep -q "22.*DENY"; then
            report_finding "PASS" "Default SSH port (22) is blocked"
        else
            report_finding "MEDIUM" "Default SSH port (22) not explicitly blocked"
        fi
    else
        report_finding "CRITICAL" "UFW firewall is inactive" "Enable with: sudo ufw enable"
    fi
else
    report_finding "CRITICAL" "UFW not installed" "Install with: sudo apt install ufw"
fi

# 3. Fail2Ban Status
echo -e "${BLUE}━━━ Intrusion Prevention ━━━${NC}"
echo ""

if command -v fail2ban-client &> /dev/null; then
    if sudo systemctl is-active --quiet fail2ban; then
        report_finding "PASS" "Fail2Ban is active"
        
        # Check SSH jail
        if sudo fail2ban-client status sshd &>/dev/null; then
            BANNED=$(sudo fail2ban-client status sshd | grep "Currently banned" | awk '{print $4}')
            report_finding "PASS" "SSH jail active (currently banned: $BANNED IPs)"
        else
            report_finding "MEDIUM" "SSH jail not configured"
        fi
    else
        report_finding "HIGH" "Fail2Ban installed but not running" "Start with: sudo systemctl start fail2ban"
    fi
else
    report_finding "HIGH" "Fail2Ban not installed" "Install with: sudo apt install fail2ban"
fi

# 4. User Security
echo -e "${BLUE}━━━ User Security ━━━${NC}"
echo ""

# Check for users with UID 0 (root privileges)
ROOT_USERS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd | grep -v "^root$" || true)
if [ -n "$ROOT_USERS" ]; then
    report_finding "CRITICAL" "Non-root users with UID 0 found" "Users: $ROOT_USERS"
else
    report_finding "PASS" "No unauthorized root-level users"
fi

# Check for users with empty passwords
EMPTY_PASS=$(sudo awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow | grep -v "^root$" || true)
if [ -n "$EMPTY_PASS" ]; then
    report_finding "HIGH" "Users with empty/locked passwords" "Review: $EMPTY_PASS"
else
    report_finding "PASS" "No users with empty passwords"
fi

# Check if default ubuntu user still exists
if getent passwd ubuntu > /dev/null; then
    report_finding "MEDIUM" "Default 'ubuntu' user still exists" "Remove after creating secure user"
else
    report_finding "PASS" "Default 'ubuntu' user removed"
fi

# 5. System Updates
echo -e "${BLUE}━━━ System Updates ━━━${NC}"
echo ""

# Check for available updates
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c "upgradable" || echo "0")
if [ "$UPDATES" -gt 50 ]; then
    report_finding "HIGH" "$UPDATES packages need updating" "Run: sudo apt update && sudo apt upgrade"
elif [ "$UPDATES" -gt 10 ]; then
    report_finding "MEDIUM" "$UPDATES packages need updating"
elif [ "$UPDATES" -gt 0 ]; then
    report_finding "LOW" "$UPDATES packages need updating"
else
    report_finding "PASS" "System is up to date"
fi

# Check unattended-upgrades
if dpkg -l | grep -q unattended-upgrades; then
    report_finding "PASS" "Automatic security updates configured"
else
    report_finding "MEDIUM" "Automatic updates not configured" "Install: sudo apt install unattended-upgrades"
fi

# 6. Docker Security
echo -e "${BLUE}━━━ Docker Security ━━━${NC}"
echo ""

if command -v docker &> /dev/null; then
    # Check Docker daemon configuration
    if [ -f /etc/docker/daemon.json ]; then
        report_finding "PASS" "Docker daemon.json exists"
        
        # Check log rotation
        if grep -q "max-size" /etc/docker/daemon.json; then
            report_finding "PASS" "Docker log rotation configured"
        else
            report_finding "MEDIUM" "Docker log rotation not configured"
        fi
    else
        report_finding "MEDIUM" "Docker daemon.json not found" "Create production config"
    fi
    
    # Check for containers running as root
    ROOT_CONTAINERS=$(sudo docker ps --format "{{.Names}}" --filter "user=root" 2>/dev/null | wc -l || echo "0")
    if [ "$ROOT_CONTAINERS" -gt 0 ]; then
        report_finding "LOW" "$ROOT_CONTAINERS containers running as root" "Consider using non-root users"
    fi
    
    # Check Docker socket permissions
    if [ -S /var/run/docker.sock ]; then
        SOCKET_PERMS=$(stat -c %a /var/run/docker.sock)
        if [ "$SOCKET_PERMS" = "666" ] || [ "$SOCKET_PERMS" = "777" ]; then
            report_finding "HIGH" "Docker socket has insecure permissions: $SOCKET_PERMS" "Should be 660"
        else
            report_finding "PASS" "Docker socket permissions OK: $SOCKET_PERMS"
        fi
    fi
else
    report_finding "LOW" "Docker not installed"
fi

# 7. Network Security
echo -e "${BLUE}━━━ Network Security ━━━${NC}"
echo ""

# Check open ports
OPEN_PORTS=$(ss -tuln | grep LISTEN | awk '{print $5}' | sed 's/.*://' | sort -u | wc -l)
report_finding "PASS" "$OPEN_PORTS unique ports listening"

# Check if port 3000 is exposed externally (should be blocked after SSL)
if ss -tuln | grep -q ":3000 "; then
    if sudo iptables -L DOCKER-USER -n 2>/dev/null | grep -q "tcp dpt:3000.*DROP"; then
        report_finding "PASS" "Port 3000 blocked externally (iptables)"
    else
        report_finding "MEDIUM" "Port 3000 open" "Block after SSL setup with post_ssl_setup.sh"
    fi
fi

# 8. File System Security
echo -e "${BLUE}━━━ File System Security ━━━${NC}"
echo ""

# Check for world-writable files in critical directories
WORLD_WRITABLE=$(find /etc /usr/bin /usr/sbin -type f -perm -002 2>/dev/null | wc -l || echo "0")
if [ "$WORLD_WRITABLE" -gt 0 ]; then
    report_finding "HIGH" "$WORLD_WRITABLE world-writable files in critical directories"
else
    report_finding "PASS" "No world-writable files in critical directories"
fi

# Check /tmp permissions
TMP_PERMS=$(stat -c %a /tmp)
if [ "$TMP_PERMS" = "1777" ]; then
    report_finding "PASS" "/tmp has correct permissions (1777)"
else
    report_finding "MEDIUM" "/tmp has unusual permissions: $TMP_PERMS"
fi

# 9. Summary
echo "=================================================================="
echo "  📊 Security Audit Summary"
echo "=================================================================="
echo ""
echo -e "${RED}Critical Issues: $CRITICAL${NC}"
echo -e "${RED}High Priority: $HIGH${NC}"
echo -e "${YELLOW}Medium Priority: $MEDIUM${NC}"
echo -e "${CYAN}Low Priority: $LOW${NC}"
echo ""

TOTAL_ISSUES=$((CRITICAL + HIGH + MEDIUM + LOW))

if [ $CRITICAL -gt 0 ]; then
    echo -e "${RED}⚠️  CRITICAL ISSUES FOUND - Immediate action required!${NC}"
    exit 2
elif [ $HIGH -gt 0 ]; then
    echo -e "${YELLOW}⚠️  High priority issues found - Address soon${NC}"
    exit 1
elif [ $MEDIUM -gt 0 ]; then
    echo -e "${YELLOW}✓ Security is acceptable but can be improved${NC}"
    exit 0
else
    echo -e "${GREEN}✅ Excellent security posture!${NC}"
    exit 0
fi
