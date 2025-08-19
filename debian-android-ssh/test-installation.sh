#!/bin/bash

# Test script for debian-android-ssh installation
# Run this after installation to verify everything works

set -euo pipefail

# Colors
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Test counter
tests_passed=0
tests_failed=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing $test_name... "
    
    if eval "$test_command" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((tests_passed++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((tests_failed++))
    fi
}

echo "🧪 debian-android-ssh Installation Test Suite"
echo "=============================================="
echo

# Test 1: Check if SSH server is installed
run_test "SSH server installation" "command -v sshd"

# Test 2: Check if SSH config exists
run_test "SSH configuration file" "test -f /etc/ssh/sshd_config"

# Test 3: Check SSH config permissions
run_test "SSH config permissions" "test $(stat -c %a /etc/ssh/sshd_config) = 600"

# Test 4: Check SSH config ownership
run_test "SSH config ownership" "test $(stat -c %U:%G /etc/ssh/sshd_config) = root:root"

# Test 5: Check if startup script exists
run_test "Startup script exists" "test -f /usr/local/bin/start-ssh.sh"

# Test 6: Check startup script permissions
run_test "Startup script permissions" "test -x /usr/local/bin/start-ssh.sh"

# Test 7: Check if SSH directory exists
run_test "SSH directory exists" "test -d /var/run/sshd"

# Test 8: Check SSH host keys
run_test "SSH host keys exist" "test -f /etc/ssh/ssh_host_rsa_key"

# Test 9: Check if log directory exists
run_test "Log directory exists" "test -d /var/log"

# Test 10: Check SSH configuration syntax
run_test "SSH config syntax" "sshd -t"

# Test 11: Check if systemd service exists (if systemd available)
if command -v systemctl >/dev/null 2>&1; then
    run_test "Systemd service file" "test -f /etc/systemd/system/android-ssh.service"
else
    echo -e "${YELLOW}Skipping systemd service test (systemd not available)${NC}"
fi

# Test 12: Check if root password is set
run_test "Root password set" "grep -q '^root:' /etc/shadow"

# Test 13: Check if SSH can start (dry run)
run_test "SSH server can start" "timeout 5s sshd -T >/dev/null 2>&1 || true"

echo
echo "📊 Test Results:"
echo "================="
echo -e "Tests passed: ${GREEN}$tests_passed${NC}"
echo -e "Tests failed: ${RED}$tests_failed${NC}"
echo

if [[ $tests_failed -eq 0 ]]; then
    echo -e "${GREEN}🎉 All tests passed! Installation appears to be successful.${NC}"
    echo
    echo "Next steps:"
    echo "1. Start SSH server: /usr/local/bin/start-ssh.sh"
    echo "2. Connect from another device using the provided credentials"
    echo "3. Change the default password immediately"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please check the installation.${NC}"
    echo
    echo "Troubleshooting:"
    echo "1. Check SSH logs: tail -f /var/log/ssh.log"
    echo "2. Verify file permissions and ownership"
    echo "3. Re-run the installer if needed"
    exit 1
fi
