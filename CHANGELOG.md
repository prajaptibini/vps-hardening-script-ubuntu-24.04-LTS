# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2025-11-14

### Added
- **Mandatory custom username**: Users MUST choose their own unique username (no default for security)
- **Manual SSH key configuration**: Users must provide their own SSH public key instead of copying from ubuntu user
- **SSH_KEY_HELP.md**: Comprehensive guide for finding and generating SSH keys
- **Username persistence**: Username is saved in `/tmp/new_user_name.txt` for use across scripts
- **IPv4 and IPv6 detection**: Scripts now detect and display both IPv4 and IPv6 addresses
- **Optional tools section**: Documentation for optional monitoring and security tools

### Changed
- **create_user.sh**: Username is now REQUIRED (no default) with validation
- **All scripts**: Updated to read username from saved file instead of hardcoded value
- **install.sh**: Updated prompts to reflect mandatory username selection
- **Documentation**: Updated README.md and GUIDE.md with new username requirements

### Improved
- **Security**: Each user must provide their own SSH key, no automatic copying
- **Flexibility**: Support for custom usernames instead of hardcoded "prod-dokploy"
- **User experience**: Clear instructions and better prompts during installation
- **Focus**: Removed btop from automatic installation to keep the script focused on security and Dokploy

### Removed
- **btop automatic installation**: Now optional, users can install it manually if needed

## [2.1.0] - 2025-11-09

### Changed
- Renamed repository to `ubuntu-2404-production-deploy`
- Updated all references to new repository name
- Migrated to ZenPloy Cloud organization

### Added
- Comprehensive documentation
- .gitignore file
- LICENSE (MIT)
- GUIDE.md for quick start
- CHANGELOG.md

### Fixed
- Repository URL consistency across all scripts

## [2.0.0] - 2025-10-04

### Added
- One-command installation script
- Enhanced system health check with colors
- Docker daemon configuration script
- Automatic log rotation
- Network cleanup functionality
- Comprehensive error handling with rollback
- Prerequisites validation
- Detailed logging system

### Changed
- Improved SSH port persistence after reboot
- Enhanced security with SSH socket masking
- Simplified firewall architecture (UFW for SSH only)
- Docker manages its own ports natively

### Security
- Random SSH port (50000-59999)
- SSH socket permanently masked
- Port 3000 blocked after SSL setup
- Fail2Ban monitoring
- Automatic security updates

## [1.0.0] - Initial Release

### Added
- Basic VPS setup scripts
- Dokploy installation
- UFW firewall configuration
- SSH hardening
- User creation script

---

**Legend:**
- `Added` for new features
- `Changed` for changes in existing functionality
- `Deprecated` for soon-to-be removed features
- `Removed` for now removed features
- `Fixed` for any bug fixes
- `Security` for vulnerability fixes
- `Improved` for enhancements to existing features
