#!/bin/bash
# Ansible-based SSH Server Installer for Android Debian Container
# This script installs Ansible and runs the SSH setup playbook

set -e

# Parse command line arguments
SKIP_ENV_CHECK=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-env-check)
            SKIP_ENV_CHECK=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --skip-env-check    Skip Android environment detection"
            echo "  --help, -h         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

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
    
    # More comprehensive Android detection
    local is_android=false
    
    # Check multiple indicators of Android environment
    if grep -q "android" /proc/version 2>/dev/null; then
        is_android=true
    elif [ -d "/system" ] && [ -f "/system/build.prop" ]; then
        is_android=true
    elif [ -n "$ANDROID_DATA" ] || [ -n "$ANDROID_ROOT" ]; then
        is_android=true
    elif [ -f "/proc/cpuinfo" ] && grep -q "android" /proc/cpuinfo 2>/dev/null; then
        is_android=true
    fi
    
    # If we're in a container, also check for Android-specific paths
    if [ "$is_android" = false ] && [ -f "/proc/1/cgroup" ]; then
        if grep -q "android" /proc/1/cgroup 2>/dev/null; then
            is_android=true
        fi
    fi
    
    if [ "$is_android" = false ]; then
        if [ "$SKIP_ENV_CHECK" = true ]; then
            log "Skipping environment check as requested"
        else
            warning "This script is designed for Android containers. Continue anyway? (y/N)"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        log "Android environment detected"
    fi
}

# Install dependencies
install_dependencies() {
    log "Installing dependencies..."
    
    # Update package list
    apt-get update -y
    
    # Install required packages including git
    apt-get install -y python3 python3-pip python3-apt software-properties-common python3-full git
    
    success "Dependencies installed successfully"
}

# Install Ansible
install_ansible() {
    log "Installing Ansible..."
    
    # Try to install Ansible via pip first
    if pip3 install --break-system-packages ansible 2>/dev/null; then
        success "Ansible installed via pip"
    else
        log "Pip installation failed, trying apt..."
        
        # Try to install via apt
        if apt-get install -y ansible; then
            success "Ansible installed via apt"
        else
            log "Apt installation failed, trying alternative method..."
            
            # Create virtual environment as fallback
            python3 -m venv /tmp/ansible-venv
            /tmp/ansible-venv/bin/pip install ansible
            
            # Create symlink to make ansible available system-wide
            ln -sf /tmp/ansible-venv/bin/ansible /usr/local/bin/ansible
            ln -sf /tmp/ansible-venv/bin/ansible-playbook /usr/local/bin/ansible-playbook
            
            success "Ansible installed via virtual environment"
        fi
    fi
    
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
    install_dependencies
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
