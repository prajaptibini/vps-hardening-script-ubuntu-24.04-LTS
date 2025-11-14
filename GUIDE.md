# 🚀 Quick Installation Guide

This guide will help you set up a secure Ubuntu 24.04 VPS with Dokploy in minutes.

## Prerequisites

- Ubuntu 24.04 LTS server
- Root or sudo access
- SSH access to your server

## Installation Steps

### 1. Prepare Your SSH Key (Local Machine)

```bash
# On your LOCAL machine, get your SSH public key
cat ~/.ssh/id_ed25519.pub
# or
cat ~/.ssh/id_rsa.pub

# Copy the entire output - you'll need it during installation
```

**Don't have an SSH key?** See [SSH_KEY_HELP.md](SSH_KEY_HELP.md)

### 2. Connect to Your Server

```bash
ssh ubuntu@your-server-ip
```

### 3. Clone and Install

```bash
# Clone repository (HTTPS - no GitHub account needed)
git clone https://github.com/alexandreravelli/vps-hardening-script-ubuntu-24.04-LTS.git
cd vps-hardening-script-ubuntu-24.04-LTS
chmod +x *.sh
./install.sh
```

### 4. Follow the Prompts

**You will be prompted for:**

1. **Username** (REQUIRED)
   - Enter your preferred username
   - Must be unique and follow Linux username rules
   - Examples: admin, devops, myname, etc.

2. **SSH Public Key** (REQUIRED)
   - Paste your SSH public key from step 1

**The installer will then:**
- Create your secure user
- Configure SSH key authentication
- Grant sudo privileges

### 5. Reconnect with New User

```bash
exit
ssh <your_username>@your-server-ip
cd vps-hardening-script-ubuntu-24.04-LTS
./main_setup.sh
```

### 6. Access Dokploy

Open in browser: `http://your-server-ip:3000`

### 7. Configure SSL

1. Add your domain in Dokploy
2. Configure SSL certificate
3. Run security script:

```bash
./post_ssl_setup.sh
```

## Verification

```bash
./system_check.sh
```

## Troubleshooting

### Lost SSH Port?

```bash
cat /tmp/ssh_port_info.txt
```

### Dokploy Not Accessible?

```bash
sudo docker ps
curl http://localhost:3000
```

### Need Help?

Check the full [README.md](README.md) for detailed documentation.

## Next Steps

- Configure your applications in Dokploy
- Set up automatic backups
- Configure monitoring
- Add your domains

---

**Need more help?** Open an issue on GitHub!
