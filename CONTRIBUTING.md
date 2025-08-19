# Contributing to debian-android-ssh

Thank you for your interest in contributing to debian-android-ssh! This document provides guidelines and information for contributors.

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

- **Bash scripts**: Follow [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Comments**: Use clear, descriptive comments
- **Error handling**: Always include proper error handling
- **Security**: Consider security implications of all changes
- **Testing**: Test on actual Android devices when possible

#### Testing Guidelines

- Test on **Android 16+** with Debian terminal
- Test both **with and without systemd**
- Verify **SSH connectivity** from external devices
- Check **log files** for errors
- Test **error conditions** (network issues, permission problems)

### Documentation

We welcome improvements to:

- **README.md**: Installation instructions, usage examples
- **Troubleshooting guides**: Common issues and solutions
- **Code comments**: Inline documentation
- **Security documentation**: Best practices and recommendations

## 🛠️ Development

### Project Structure

```
debian-android-ssh/
├── install-ssh.sh      # Main installer script
├── README.md           # Project documentation
├── LICENSE             # MIT License
├── CHANGELOG.md        # Version history
├── CONTRIBUTING.md     # This file
└── .gitignore          # Git ignore rules
```

### Key Components

- **install-ssh.sh**: Main installer with comprehensive error handling
- **README.md**: User-facing documentation
- **Security features**: Hardened SSH configuration
- **Logging**: Comprehensive logging system
- **IP detection**: Multiple methods for device IP detection

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

- **Additional Android device support**
- **Enhanced security features**
- **Better error handling and recovery**
- **Improved documentation**
- **Testing and validation tools**
- **Performance optimizations**

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to debian-android-ssh! 🚀
