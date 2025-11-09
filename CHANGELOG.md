# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
