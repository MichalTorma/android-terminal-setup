# android-terminal-setup

🚀 **Complete development environment setup** for **Android 16 Terminal** - SSH server, Kubernetes (Minikube), and ArgoCD in the native Debian container environment.

> **Note**: This is specifically designed for the **Android Terminal** feature in Android 16+, which provides a native Debian container environment. This is NOT for Termux, UserLAnd, or other third-party terminal solutions.

## ✨ Features

- 🔒 **Secure by default** - Random password generation, hardened SSH configuration
- 🛡️ **Production-ready** - Declarative configuration management with Ansible
- 📱 **Android optimized** - Designed specifically for Android Terminal
- 🔧 **Flexible deployment** - Works with or without systemd
- 🎯 **Idempotent operations** - Safe to run multiple times
- ⚡ **Smart caching** - Skips installation if Ansible is already available
- 🐳 **Docker support** - Full Docker installation and configuration
- ☸️ **Kubernetes ready** - Minikube cluster with essential addons
- 🚀 **ArgoCD included** - GitOps deployment platform ready to use

## 🚀 Quick Start

### One-liner installation

```bash
apt-get update -y && apt-get install -y curl
bash <(curl -s https://raw.githubusercontent.com/MichalTorma/android-terminal-setup/main/install-ansible.sh)
```

### Manual installation

```bash
git clone https://github.com/MichalTorma/android-terminal-setup.git
cd android-terminal-setup
sudo bash install-ansible.sh
```

## 📋 Requirements

- **Android 16+** with **Android Terminal** feature enabled
- Root access (sudo) within the Android Terminal
- Internet connection for package installation

> **What is Android Terminal?**
> 
> Android Terminal is a native feature in Android 16+ that provides a full Debian container environment directly on your Android device. It's built into the Android system and provides a genuine Linux environment with full package management capabilities.

## 🔧 What gets installed

- **OpenSSH server** on port 2222
- **Ansible** (configuration management)
- **Docker** (container runtime)
- **Kubectl** (Kubernetes CLI)
- **Minikube** (local Kubernetes cluster)
- **ArgoCD** (GitOps deployment platform)
- **Secure configuration** with hardened SSH settings
- **Random password** (12 characters) generated automatically
- **Startup script** for easy management
- **Systemd service** (if available)
- **Comprehensive logging**

## 📱 Usage

### Port Forwarding

SSH runs on port **2222** by default. Set up port forwarding to access from outside:

```bash
# ADB port forwarding (recommended)
adb forward tcp:2222 tcp:2222

# Connect from your computer
ssh root@localhost -p 2222
```

> **Why port forwarding?**
> 
> Android Terminal runs in a virtualized environment with its own network interface (e.g., enp0s8 with IP 10.135.204.118). While this interface may be accessible from the Android host, port forwarding ensures reliable external access and handles any network isolation between the virtual environment and your Android device's network interfaces.

### Start SSH server

```bash
# Interactive mode
/usr/local/bin/start-ssh.sh

# Background mode
nohup /usr/local/bin/start-ssh.sh > /var/log/ssh.log 2>&1 &

# Using systemd (if available)
sudo systemctl start android-ssh
sudo systemctl enable android-ssh
```

### Connect from another device

```bash
# Basic connection
ssh root@<android-ip> -p 2222

# With verbose output
ssh -v root@<android-ip> -p 2222
```

### Check status

```bash
# Check if SSH is running
ps aux | grep sshd

# View SSH logs
tail -f /var/log/ssh.log

# Check service status (if using systemd)
sudo systemctl status android-ssh
```

## ☸️ Kubernetes & ArgoCD Usage

### Kubernetes Commands

```bash
# Check cluster status
kubectl cluster-info

# View all pods
kubectl get pods --all-namespaces

# Access Minikube dashboard
minikube dashboard

# Check Minikube status
minikube status
```

### ArgoCD Access

```bash
# Port forward ArgoCD server
kubectl port-forward -n argocd svc/argocd-server 8080:443

# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**ArgoCD Web UI**: https://localhost:8080
- **Username**: admin
- **Password**: (generated during installation)

## 🔧 Configuration

### Key Files
- **SSH config**: `/etc/ssh/sshd_config`
- **Startup script**: `/usr/local/bin/start-ssh.sh`
- **Log file**: `/var/log/ssh.log`
- **Systemd service**: `/etc/systemd/system/android-ssh.service`

### Customization

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config

# Restart SSH server
sudo pkill sshd
/usr/local/bin/start-ssh.sh
```

## 🛠️ Troubleshooting

### Common Issues

**SSH connection refused**
```bash
# Check if SSH is running
ps aux | grep sshd

# Check SSH logs
tail -f /var/log/ssh.log

# Verify port is listening
netstat -tlnp | grep :2222
```

**Port forwarding issues**
```bash
# Test local connection first
ssh root@localhost -p 2222

# Check ADB port forwarding
adb forward --list

# Check network interfaces
ip addr show

# Verify container vs host networking
# Container IP (internal): Usually 10.x.x.x (like 10.135.204.118)
# Host IP (external): Usually 192.168.x.x (WiFi/hotspot)

# If direct connection times out, use port forwarding:
adb forward tcp:2222 tcp:2222
ssh root@localhost -p 2222
```

**"externally-managed-environment" error**
```bash
# The installer handles this automatically, but if installing manually:
pip3 install --break-system-packages ansible
# or
apt-get install -y ansible
```

**Direct connection timeout**
```bash
# If ssh root@10.135.204.118 -p 2222 times out:
# This is normal - the virtual network is isolated

# Solution: Use port forwarding instead
adb forward tcp:2222 tcp:2222
ssh root@localhost -p 2222

# Alternative: Check if SSH is running locally first
ssh root@localhost -p 2222  # Should work from within Android Terminal
```

## 🔄 Updates and Maintenance

### Reconfiguring with Ansible
```bash
# Safe to run multiple times (idempotent)
ansible-playbook -i inventory.ini ansible-playbook.yml -v
```

### Updating SSH server
```bash
sudo apt-get update && sudo apt-get upgrade openssh-server
```

## ⚠️ Security Notice

- **Change the default password** immediately after first login
- **Use SSH keys** instead of passwords for better security
- **Keep the system updated** regularly
- **Monitor logs** for suspicious activity

## 📞 Support

If you encounter issues:
1. Check the [troubleshooting section](#troubleshooting)
2. Review SSH logs: `tail -f /var/log/ssh.log`
3. Open an issue on GitHub with detailed information

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Made with ❤️ for the Android developer community**
