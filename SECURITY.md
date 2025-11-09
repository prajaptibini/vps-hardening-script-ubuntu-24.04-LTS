# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.1.x   | :white_check_mark: |
| 2.0.x   | :white_check_mark: |
| < 2.0   | :x:                |

## Security Features

This project implements several security best practices:

### SSH Hardening
- Random SSH port (50000-59999)
- SSH socket permanently masked
- Root login disabled
- Key-based authentication enforced
- Fail2Ban monitoring

### Firewall Configuration
- UFW firewall for SSH protection
- Default deny incoming policy
- Docker manages container ports natively
- Port 3000 blocked after SSL setup (iptables)

### System Security
- Automatic security updates
- Secure user creation with sudo privileges
- Default user removal after setup
- Comprehensive logging with rotation

### Docker Security
- Log rotation (max 30MB per container)
- Optimized storage driver (overlay2)
- Network isolation
- Health checks before deployment

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via:

1. **Email**: security@zenploy.cloud (if available)
2. **Private Security Advisory**: Use GitHub's private vulnerability reporting feature

### What to Include

- Type of vulnerability
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity
  - Critical: 1-7 days
  - High: 7-14 days
  - Medium: 14-30 days
  - Low: 30-90 days

## Security Best Practices for Users

### Before Installation

1. **Use a fresh Ubuntu 24.04 LTS installation**
2. **Update system**: `sudo apt update && sudo apt upgrade -y`
3. **Backup important data**
4. **Use strong passwords**

### During Installation

1. **Review scripts before execution**
2. **Use SSH keys, not passwords**
3. **Save SSH port information securely**
4. **Document your configuration**

### After Installation

1. **Run system check**: `./system_check.sh`
2. **Configure SSL certificates immediately**
3. **Run post-SSL security**: `./post_ssl_setup.sh`
4. **Set up monitoring and alerts**
5. **Regular backups**
6. **Keep system updated**

### Regular Maintenance

```bash
# Weekly checks
./system_check.sh

# Monthly updates
sudo apt update && sudo apt upgrade -y

# Check logs
tail -f /var/log/vps_setup.log

# Monitor Fail2Ban
sudo fail2ban-client status sshd

# Check firewall
sudo ufw status numbered
```

## Known Security Considerations

### SSH Port Change
- Save your SSH port securely
- Test new connection before closing current session
- Keep OVH console access available as backup

### Port 3000 Exposure
- Port 3000 is open until SSL is configured
- Run `post_ssl_setup.sh` immediately after SSL setup
- Verify with: `sudo iptables -L DOCKER-USER -n`

### Docker Port Management
- Docker bypasses UFW by default (by design)
- Ports 80 and 443 are open for web traffic
- Use Dokploy's built-in security features

### Default User Removal
- Default user is removed at end of setup
- Ensure new user has proper SSH access first
- Keep OVH console access as backup

## Security Audit

To audit your installation:

```bash
# Check SSH configuration
sudo sshd -t
cat /etc/ssh/sshd_config | grep -E "Port|PermitRootLogin|PasswordAuthentication"

# Check firewall rules
sudo ufw status verbose
sudo iptables -L -n -v

# Check Fail2Ban
sudo fail2ban-client status

# Check Docker security
docker info | grep -i security

# Check system updates
sudo apt list --upgradable

# Review logs
sudo journalctl -u ssh -n 50
sudo journalctl -u fail2ban -n 50
tail -100 /var/log/vps_setup.log
```

## Compliance

This project follows:
- OWASP Security Best Practices
- CIS Ubuntu Linux Benchmark (selected controls)
- Docker Security Best Practices

## Updates and Patches

Security updates are released as soon as possible after discovery. Subscribe to:
- GitHub repository releases
- GitHub security advisories

## Disclaimer

This software is provided "as is" without warranty. Users are responsible for:
- Proper configuration
- Regular updates
- Security monitoring
- Backup procedures

---

**Last Updated**: 2025-11-09  
**Version**: 2.1.0
