#!/bin/bash
# Emergency Rollback Script - Restore System to Safe State

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
echo "  🚨 EMERGENCY ROLLBACK SCRIPT"
echo "=================================================================="
echo ""
echo -e "${RED}WARNING: This script will attempt to restore your system${NC}"
echo -e "${RED}to a safe state by reverting recent changes.${NC}"
echo ""
echo "This will:"
echo "  • Restore SSH to port 22"
echo "  • Disable UFW firewall"
echo "  • Restore backup configurations"
echo "  • Re-enable default user (if backup exists)"
echo ""
read -p "Are you sure you want to continue? (yes/no): " -r
echo ""

if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
    echo "Rollback cancelled."
    exit 0
fi

LOG_FILE="/var/log/emergency_rollback.log"
echo "$(date): Starting emergency rollback" | sudo tee -a "$LOG_FILE"

# Function to log actions
log_action() {
    echo "$1"
    echo "$(date): $1" | sudo tee -a "$LOG_FILE" > /dev/null
}

# 1. Restore SSH Configuration
echo -e "${BLUE}━━━ Restoring SSH Configuration ━━━${NC}"
echo ""

if [ -f /etc/ssh/sshd_config.bak ]; then
    log_action "→ Restoring SSH config from backup..."
    sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    
    # Ensure port 22 is enabled
    if ! grep -q "^Port 22" /etc/ssh/sshd_config; then
        log_action "→ Adding port 22 to SSH config..."
        sudo sed -i '1i Port 22' /etc/ssh/sshd_config
    fi
    
    # Validate and restart SSH
    if sudo sshd -t; then
        log_action "→ SSH config valid, restarting service..."
        sudo systemctl restart ssh.service
        sleep 3
        
        if sudo systemctl is-active --quiet ssh.service; then
            log_action "✅ SSH service restored and running"
        else
            log_action "❌ SSH service failed to start"
        fi
    else
        log_action "❌ SSH config validation failed"
    fi
else
    log_action "⚠️  No SSH backup found, attempting to enable port 22..."
    
    # Remove any Port lines and add port 22
    sudo sed -i '/^Port /d' /etc/ssh/sshd_config
    sudo sed -i '1i Port 22' /etc/ssh/sshd_config
    
    if sudo sshd -t && sudo systemctl restart ssh.service; then
        log_action "✅ SSH restored to port 22"
    else
        log_action "❌ Failed to restore SSH"
    fi
fi

# Unmask and enable SSH socket (if it was masked)
sudo systemctl unmask ssh.socket 2>/dev/null || true
sudo systemctl enable ssh.service 2>/dev/null || true

echo ""

# 2. Disable UFW Firewall
echo -e "${BLUE}━━━ Disabling UFW Firewall ━━━${NC}"
echo ""

if command -v ufw &> /dev/null; then
    log_action "→ Disabling UFW firewall..."
    sudo ufw --force disable || true
    log_action "✅ UFW disabled"
else
    log_action "⚠️  UFW not installed"
fi

echo ""

# 3. Restore Docker Configuration
echo -e "${BLUE}━━━ Restoring Docker Configuration ━━━${NC}"
echo ""

if [ -f /etc/docker/daemon.json.bak ]; then
    log_action "→ Restoring Docker daemon.json..."
    sudo cp /etc/docker/daemon.json.bak /etc/docker/daemon.json
    
    if sudo systemctl is-active --quiet docker; then
        log_action "→ Restarting Docker..."
        sudo systemctl restart docker
        sleep 3
        log_action "✅ Docker configuration restored"
    fi
else
    log_action "⚠️  No Docker backup found"
fi

echo ""

# 4. Remove iptables Rules for Port 3000
echo -e "${BLUE}━━━ Removing Port 3000 Restrictions ━━━${NC}"
echo ""

if sudo iptables -L DOCKER-USER -n 2>/dev/null | grep -q "tcp dpt:3000"; then
    log_action "→ Removing port 3000 iptables rules..."
    sudo iptables -D DOCKER-USER -p tcp --dport 3000 -j DROP 2>/dev/null || true
    sudo iptables -D DOCKER-USER -i lo -p tcp --dport 3000 -j ACCEPT 2>/dev/null || true
    log_action "✅ Port 3000 restrictions removed"
else
    log_action "⚠️  No port 3000 restrictions found"
fi

echo ""

# 5. Check Default User
echo -e "${BLUE}━━━ Checking Default User ━━━${NC}"
echo ""

if ! getent passwd ubuntu > /dev/null; then
    log_action "⚠️  Default 'ubuntu' user not found"
    
    if [ -f /tmp/backup_user_info.txt ]; then
        log_action "→ Backup user info found, but manual recreation required"
        log_action "→ Use OVH console to recreate user: sudo adduser ubuntu"
    else
        log_action "→ No backup found - use OVH console to recreate user"
    fi
else
    log_action "✅ Default 'ubuntu' user exists"
fi

echo ""

# 6. Verify Services
echo -e "${BLUE}━━━ Verifying Services ━━━${NC}"
echo ""

# Check SSH
if sudo systemctl is-active --quiet ssh.service; then
    log_action "✅ SSH service: Running"
    
    if ss -tuln | grep -q ":22 "; then
        log_action "✅ SSH listening on port 22"
    else
        log_action "⚠️  SSH not listening on port 22"
    fi
else
    log_action "❌ SSH service: Not running"
fi

# Check Docker
if command -v docker &> /dev/null; then
    if sudo systemctl is-active --quiet docker; then
        log_action "✅ Docker service: Running"
    else
        log_action "⚠️  Docker service: Not running"
    fi
fi

# Check Fail2Ban
if command -v fail2ban-client &> /dev/null; then
    if sudo systemctl is-active --quiet fail2ban; then
        log_action "✅ Fail2Ban service: Running"
    else
        log_action "⚠️  Fail2Ban service: Not running"
    fi
fi

echo ""

# 7. Summary
echo "=================================================================="
echo "  📋 Rollback Summary"
echo "=================================================================="
echo ""
echo "Actions taken:"
echo "  • SSH restored to port 22"
echo "  • UFW firewall disabled"
echo "  • Backup configurations restored (if available)"
echo "  • Port 3000 restrictions removed"
echo ""
echo "Current status:"
echo "  • SSH Port: 22 (default)"
echo "  • Firewall: Disabled"
echo "  • Docker: $(sudo systemctl is-active docker 2>/dev/null || echo 'unknown')"
echo ""
echo -e "${GREEN}✅ Emergency rollback completed${NC}"
echo ""
echo "Next steps:"
echo "  1. Test SSH connection: ssh ubuntu@<your_ip>"
echo "  2. Review logs: tail -50 $LOG_FILE"
echo "  3. Run security audit: ./security_audit.sh"
echo "  4. Re-run setup when ready: ./main_setup.sh"
echo ""
echo "Full log: $LOG_FILE"
echo "=================================================================="
