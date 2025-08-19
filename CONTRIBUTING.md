# Contributing to android-terminal-setup

Thank you for your interest in contributing to android-terminal-setup! This document provides guidelines and information for contributors.

> **Note**: This project is specifically designed for the **Android Terminal** feature in Android 16+, which provides a native Debian container environment. This is NOT for Termux, UserLAnd, or other third-party terminal solutions.

## 🤝 How to Contribute

### Reporting Issues

Before creating an issue, please:

1. **Search existing issues** to avoid duplicates
2. **Check the troubleshooting section** in the README
3. **Provide detailed information** including:
   - Android version and device model
   - Debian terminal version
   - Complete error messages
   - Steps to reproduce the issue
   - SSH logs (`tail -f /var/log/ssh.log`)

### Feature Requests

We welcome feature requests! Please:

1. **Describe the feature** clearly and concisely
2. **Explain the use case** and why it's needed
3. **Consider security implications** for SSH-related features
4. **Check if it's Android-specific** and relevant to our target audience

### Code Contributions

#### Development Setup

1. **Fork the repository**
2. **Clone your fork** locally
3. **Create a feature branch** from `main`
4. **Make your changes** following the coding standards
5. **Test thoroughly** on Android Debian terminal
6. **Submit a pull request**

#### Coding Standards

- **Ansible playbooks**: Follow [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- **YAML**: Use consistent indentation and clear structure
- **Templates**: Use descriptive variable names and comments
- **Error handling**: Always include proper error handling and validation
- **Security**: Consider security implications of all changes
- **Testing**: Test on actual Android devices when possible

#### Testing Guidelines

- Test on **Android 16+** with **Android Terminal** feature enabled
- Test both **with and without systemd**
- Verify **SSH connectivity** from external devices via port forwarding
- Check **log files** for errors
- Test **error conditions** (network issues, permission problems)
- Test **Ansible playbook idempotency** (run multiple times safely)
- Validate **template configurations** and variable substitution
- Test **port forwarding** scenarios (ADB, Android Studio, etc.)

### Documentation

We welcome improvements to:

- **README.md**: Installation instructions, usage examples
- **Troubleshooting guides**: Common issues and solutions
- **Code comments**: Inline documentation
- **Security documentation**: Best practices and recommendations

## 🛠️ Development

### Project Structure

```
android-terminal-setup/
├── ansible-playbook.yml    # Main Ansible playbook
├── install-ansible.sh      # Ansible installer script
├── inventory.ini           # Ansible inventory
├── requirements.txt        # Python dependencies
├── templates/              # Configuration templates
│   ├── sshd_config.j2      # SSH configuration template
│   ├── start-ssh.sh.j2     # SSH startup script template
│   └── android-ssh.service.j2 # Systemd service template
├── README.md               # Project documentation
├── LICENSE                 # MIT License
├── CHANGELOG.md            # Version history
├── CONTRIBUTING.md         # This file
└── .gitignore              # Git ignore rules
```

### Key Components

- **ansible-playbook.yml**: Main Ansible playbook with comprehensive configuration management
- **install-ansible.sh**: Ansible installer script with dependency management
- **templates/**: Version-controlled configuration templates
- **README.md**: User-facing documentation
- **Security features**: Hardened SSH configuration via templates
- **Logging**: Comprehensive logging system
- **IP detection**: Multiple methods for device IP detection
- **Idempotent operations**: Safe to run multiple times

### Security Considerations

When contributing, please consider:

- **SSH security**: All changes must maintain or improve security
- **File permissions**: Proper permissions for SSH configuration
- **Password handling**: Secure password generation and storage
- **Network security**: Safe default configurations
- **Logging**: Appropriate logging without exposing sensitive data

## 📋 Pull Request Process

1. **Update CHANGELOG.md** with your changes
2. **Test thoroughly** on Android devices
3. **Update documentation** if needed
4. **Ensure all tests pass** (if applicable)
5. **Request review** from maintainers

### PR Guidelines

- **Clear title** describing the change
- **Detailed description** of what was changed and why
- **Testing information** including devices tested on
- **Screenshots** for UI changes (if applicable)
- **Security review** for security-related changes

## 🐛 Bug Reports

When reporting bugs, please include:

```bash
# System information
cat /etc/debian_version
uname -a
ps aux | grep sshd

# SSH logs
tail -f /var/log/ssh.log

# Network information
ip addr show
ip route get 8.8.8.8

# SSH configuration
cat /etc/ssh/sshd_config
```

## 📞 Getting Help

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For general questions and community support
- **Security Issues**: Please report security issues privately

## 🎯 Areas for Contribution

We're particularly interested in contributions for:

- **Enhanced Android Terminal integration**
- **Improved port forwarding automation**
- **Enhanced security features**
- **Better error handling and recovery**
- **Improved documentation**
- **Testing and validation tools** (Molecule, etc.)
- **Performance optimizations**
- **Additional Ansible roles and playbooks**
- **Template improvements and customization options**
- **Android Terminal-specific optimizations**

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to android-terminal-setup! 🚀
