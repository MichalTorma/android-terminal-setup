# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-19

### Added
- Initial release of android-terminal-setup with Ansible-based configuration management
- One-liner installation script for OpenSSH server
- Automatic random password generation (12 characters)
- Comprehensive error handling and logging
- Smart device IP detection
- Secure SSH configuration with hardened settings
- Backup of existing SSH configurations
- Systemd service file creation (when available)
- Colorized output with status indicators
- Pre-flight checks for root access and Debian environment
- Detection of existing SSH installations
- Comprehensive documentation and troubleshooting guide

### Security
- Secure file permissions (600 for config, 755 for directories)
- Hardened SSH configuration with security best practices
- No empty passwords allowed
- Limited authentication attempts (3 max)
- Session limits (10 max sessions)
- Client keepalive settings for connection stability

### Features
- Works with or without systemd
- Android-optimized for Debian containers
- Zero additional dependencies beyond curl and bash
- Comprehensive logging to `/var/log/ssh.log`
- Easy startup script management
- Detailed connection information display
- Multiple IP detection methods (wlan0, eth0, route-based)

### Documentation
- Comprehensive README with usage examples
- Troubleshooting section with common issues
- Security best practices and recommendations
- Installation and configuration guides
- MIT License for open source distribution
