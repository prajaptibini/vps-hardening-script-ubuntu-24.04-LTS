# 🚀 Quick Installation Guide

This guide will help you set up a secure Ubuntu 24.04 VPS with Dokploy in minutes.

## Prerequisites

- Ubuntu 24.04 LTS server
- Root or sudo access
- SSH access to your server
- GitHub account (for SSH key authentication)

## Installation Steps

### 1. Connect to Your Server

```bash
ssh ubuntu@your-server-ip
```

### 2. Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "vps@dokploy"
# Press Enter 3 times to accept defaults

# Display your public key
cat ~/.ssh/id_ed25519.pub
```

### 3. Add SSH Key to GitHub

1. Copy the output from the previous command
2. Go to: https://github.com/settings/keys
3. Click "New SSH key"
4. Paste your key and save

### 4. Clone and Install

```bash
git clone git@github.com:ZenPloy-cloud/ubuntu-2404-production-deploy.git
cd ubuntu-2404-production-deploy
chmod +x *.sh
./install.sh
```

### 5. Follow the Prompts

The installer will:
- Create a secure user `prod-dokploy`
- Change SSH port to random (50000-59999)
- Configure firewall
- Install Docker and Dokploy

### 6. Reconnect with New User

```bash
exit
ssh prod-dokploy@your-server-ip
cd ubuntu-2404-production-deploy
./main_setup.sh
```

### 7. Access Dokploy

Open in browser: `http://your-server-ip:3000`

### 8. Configure SSL

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
