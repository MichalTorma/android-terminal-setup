#!/bin/bash
# Ansible-based SSH Server Installer for Android Debian Container
# This script installs Ansible and runs the SSH setup playbook

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/MichalTorma/android-terminal-setup.git"
TEMP_DIR="/tmp/android-ssh-setup"

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Check if running on Android Debian
check_environment() {
    if [ ! -f /etc/debian_version ]; then
        error "This script is designed for Debian-based systems only"
        exit 1
    fi
    
    if ! grep -q "android" /proc/version 2>/dev/null; then
        warning "This script is designed for Android containers. Continue anyway? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Install Ansible
install_ansible() {
    log "Installing Ansible..."
    
    # Update package list
    apt-get update -y
    
    # Install required packages
    apt-get install -y python3 python3-pip python3-apt software-properties-common
    
    # Install Ansible
    pip3 install ansible
    
    # Verify installation
    if ! ansible --version > /dev/null 2>&1; then
        error "Failed to install Ansible"
        exit 1
    fi
    
    success "Ansible installed successfully"
}

# Clone repository and run playbook
run_playbook() {
    log "Setting up SSH server with Ansible..."
    
    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Clone repository
    if [ -d ".git" ]; then
        log "Repository already exists, updating..."
        git pull origin main
    else
        log "Cloning repository..."
        git clone "$REPO_URL" .
    fi
    
    # Run Ansible playbook
    log "Running Ansible playbook..."
    ansible-playbook -i inventory.ini ansible-playbook.yml -v
    
    success "SSH server setup completed!"
}

# Cleanup
cleanup() {
    log "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}

# Main execution
main() {
    log "=== Android SSH Server Setup (Ansible Edition) ==="
    
    check_root
    check_environment
    install_ansible
    run_playbook
    cleanup
    
    log "Setup completed successfully!"
    log "You can now connect to your Android device via SSH"
}

# Handle cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
