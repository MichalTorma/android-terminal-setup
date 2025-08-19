# android-terminal-setup

🚀 **Ansible-based SSH server setup** for **Android 16 Terminal** - the native Debian container environment in Android 16+. Enterprise-grade configuration management with declarative playbooks, idempotent operations, and comprehensive security hardening.

> **Note**: This is specifically designed for the **Android Terminal** feature in Android 16+, which provides a native Debian container environment. This is NOT for Termux, UserLAnd, or other third-party terminal solutions.

## ✨ Features

- 🔒 **Secure by default** - Random password generation, proper file permissions
- 🛡️ **Production-ready** - Declarative configuration management with Ansible
- 📱 **Android optimized** - Designed specifically for Android Debian containers
- 🔧 **Flexible deployment** - Works with or without systemd
- 📊 **Smart detection** - Auto-detects device IP and existing installations
- 🎯 **Idempotent operations** - Safe to run multiple times
- 🔄 **Version controlled** - All configurations managed through templates
- 🧪 **Testable** - Easy to test and validate configurations

## 🚀 Quick Start

### One-liner installation (in Android Terminal)

```bash
apt-get update -y && apt-get install -y curl
bash <(curl -s https://raw.githubusercontent.com/MichalTorma/android-terminal-setup/main/install-ansible.sh)
```

**Note**: If you get environment detection warnings, you can skip them:
```bash
bash <(curl -s https://raw.githubusercontent.com/MichalTorma/android-terminal-setup/main/install-ansible.sh) --skip-env-check
```

### Manual installation

```bash
# Clone the repository
git clone https://github.com/MichalTorma/android-terminal-setup.git
cd android-terminal-setup

# Run Ansible installer
sudo bash install-ansible.sh

# Or skip environment check if needed
sudo bash install-ansible.sh --skip-env-check
```

### Advanced: Direct Ansible usage

```bash
# Install Ansible manually (handles externally managed environments)
apt-get update -y && apt-get install -y python3 python3-pip python3-full

# Try pip with break-system-packages flag
pip3 install --break-system-packages ansible

# Or use apt (alternative method)
apt-get install -y ansible

# Clone and run playbook
git clone https://github.com/MichalTorma/android-terminal-setup.git
cd android-terminal-setup
ansible-playbook -i inventory.ini ansible-playbook.yml -v
```

## 📋 Requirements

- **Android 16+** with **Android Terminal** feature enabled
- **Android Terminal** provides a native Debian container environment
- Root access (sudo) within the Android Terminal
- Internet connection for package installation
- Python 3.6+ (installed automatically)
- Ansible 2.9+ (installed automatically)
- Git (installed automatically)

> **What is Android Terminal?**
> 
> Android Terminal is a native feature in Android 16+ that provides a full Debian container environment directly on your Android device. It's not a third-party app like Termux - it's built into the Android system and provides a genuine Linux environment with full package management capabilities.

## 🔧 What gets installed

- **OpenSSH server** - Latest version from Debian repositories
- **Ansible** - Configuration management tool for reliable deployments
- **Git** - Version control for repository cloning
- **Secure configuration** - Hardened SSH settings via templated configuration
- **Random password** - 12-character secure password generated automatically
- **Startup script** - `/usr/local/bin/start-ssh.sh` for easy management
- **Systemd service** - Optional service file if systemd is available
- **Logging** - Comprehensive logging to `/var/log/ssh.log`
- **Templates** - Version-controlled configuration templates

## 🔐 Security Features

- ✅ Random password generation (12 characters)
- ✅ Secure file permissions (600 for config, 755 for directories)
- ✅ Hardened SSH configuration
- ✅ Backup of existing configurations
- ✅ No empty passwords allowed
- ✅ Limited authentication attempts (3 max)
- ✅ Session limits (10 max sessions)
- ✅ Client keepalive settings

## 📱 Usage

### Port Forwarding Setup

Since Android Terminal runs in a containerized environment, port forwarding is required to access SSH from outside the Android device. SSH is configured to run on port **2222** by default for easier port forwarding setup.

**Port forwarding methods for Android Terminal:**
- **ADB port forwarding** (recommended): `adb forward tcp:2222 tcp:2222`
- **Android Studio**: Configure port forwarding in the emulator settings
- **Physical device**: Use ADB over USB or wireless debugging
- **Development tools**: Most Android development tools support port forwarding to the Android Terminal container

### Start SSH server

```bash
# Interactive mode (foreground)
/usr/local/bin/start-ssh.sh

# Background mode
nohup /usr/local/bin/start-ssh.sh > /var/log/ssh.log 2>&1 &

# Using systemd (if available)
sudo systemctl start android-ssh
sudo systemctl enable android-ssh
```

### Connect from another device

```bash
# Basic connection (port 2222)
ssh root@<android-ip> -p 2222

# With verbose output for debugging
ssh -v root@<android-ip> -p 2222

# If you've forwarded a different port, use that instead
ssh root@<host-ip> -p <forwarded-port>
```

### Check status

```bash
# Check if SSH is running
ps aux | grep sshd

# View SSH logs
tail -f /var/log/ssh.log

# Check SSH service status (if using systemd)
sudo systemctl status android-ssh
```

## 🔧 Configuration

### SSH Configuration File
- **Location**: `/etc/ssh/sshd_config`
- **Backup**: Automatically backed up before modification
- **Permissions**: 600 (root:root)

### Key Files
- **Startup script**: `/usr/local/bin/start-ssh.sh`
- **Log file**: `/var/log/ssh.log`
- **Systemd service**: `/etc/systemd/system/android-ssh.service` (if available)

### Customization

After installation, you can customize the SSH configuration:

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config

# Restart SSH server
sudo pkill sshd
/usr/local/bin/start-ssh.sh
```

## 🛠️ Troubleshooting

### Common Issues

**System compatibility check**
```bash
# The installer checks for Debian-based systems (including Android Terminal).
# If you encounter issues, the system information will be displayed for debugging.
# The playbook works on any Debian-based system, not just Android Terminal.
```

**"externally-managed-environment" error during Ansible installation**
```bash
# This error occurs on newer Debian systems. The installer handles this automatically,
# but if you're installing manually, use one of these methods:

# Method 1: Use the --break-system-packages flag
pip3 install --break-system-packages ansible

# Method 2: Install via apt (recommended)
apt-get install -y ansible

# Method 3: Use virtual environment
python3 -m venv /tmp/ansible-venv
/tmp/ansible-venv/bin/pip install ansible
```

**SSH connection refused**
```bash
# Check if SSH is running
ps aux | grep sshd

# Check SSH logs
tail -f /var/log/ssh.log

# Verify port is listening (should be 2222)
netstat -tlnp | grep :2222

# Check if port forwarding is set up correctly
adb forward --list  # If using ADB
```

**Permission denied**
```bash
# Check SSH config permissions
ls -la /etc/ssh/sshd_config

# Fix permissions if needed
sudo chmod 600 /etc/ssh/sshd_config
sudo chown root:root /etc/ssh/sshd_config
```

**Can't find device IP**
```bash
# Manual IP detection
ip addr show
ip route get 8.8.8.8
```

**Port forwarding issues**
```bash
# Verify SSH is listening on the correct port
netstat -tlnp | grep :2222

# Test local connection first (within Android Terminal)
ssh root@localhost -p 2222

# Check if port forwarding is working
telnet localhost 2222  # Should connect if SSH is running

# For ADB port forwarding (from your computer)
adb forward tcp:2222 tcp:2222
adb forward --list  # Verify the forward is active

# Connect from your computer after port forwarding
ssh root@localhost -p 2222
```

### Logs and Debugging

```bash
# View SSH server logs
tail -f /var/log/ssh.log

# Test SSH configuration
sudo sshd -t

# Verbose SSH server startup
sudo sshd -D -e -d
```

## 🔄 Updates and Maintenance

### Updating SSH server
```bash
sudo apt-get update
sudo apt-get upgrade openssh-server
```

### Reconfiguring with Ansible
```bash
# Ansible playbooks are idempotent - safe to run multiple times
ansible-playbook -i inventory.ini ansible-playbook.yml -v
```

### Updating the entire setup
```bash
# Pull latest changes and reapply
git pull origin main
ansible-playbook -i inventory.ini ansible-playbook.yml -v
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## ⚠️ Security Notice

- **Change the default password** immediately after first login
- **Use SSH keys** instead of passwords for better security
- **Keep the system updated** regularly
- **Monitor logs** for suspicious activity

## 📞 Support

If you encounter any issues:

1. Check the [troubleshooting section](#troubleshooting)
2. Review the SSH logs: `tail -f /var/log/ssh.log`
3. Open an issue on GitHub with detailed information

---

**Made with ❤️ for the Android developer community**
