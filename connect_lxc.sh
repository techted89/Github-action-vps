#!/usr/bin/env bash
set -euo pipefail

# Source .env secret variables (updated each run via GITHUB_ENV / $vars)
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

echo "=== LXC SSH Connection (via .env / repo secret vars) ==="
echo "Host: ${LXC_SSH_HOST:-10.0.3.129}"
echo "User: ${LXC_SSH_USER:-root}"
echo "Key file: ${LXC_SSH_KEY_FILE:-/tmp/ssh-artifacts/id_ed25519}"
LXC_KEY_STATUS="NOT_GENERATED"
if [ -n "${LXC_SSH_PRIVATE_KEY:-}" ] && [ "$LXC_SSH_PRIVATE_KEY" != "NOT_GENERATED" ]; then
    LXC_KEY_STATUS="SET (len=${#LXC_SSH_PRIVATE_KEY})"
fi
echo "Private key set: $LXC_KEY_STATUS"

# If the SSH key file exists, attempt connection
if [ -f "${LXC_SSH_KEY_FILE:-}" ]; then
    echo "[+] Key file exists at: $LXC_SSH_KEY_FILE"
    # Verify SSH key format
    ssh-keygen -l -f "$LXC_SSH_KEY_FILE" 2>/dev/null || echo "[!] Key file exists but may not be a valid private key"
else
    echo "[!] Key file not found at: $LXC_SSH_KEY_FILE"
    echo "    (Key will be generated on next workflow run and exported to GITHUB_ENV)"
fi

# If SSH_HOST is set and reachable, attempt connection
if [ -n "${SSH_HOST:-}" ]; then
    echo "[+] SSH_HOST configured: $SSH_HOST"
    # Check if host is reachable
    ping -c 1 -W 2 "$SSH_HOST" 2>/dev/null || echo "[!] Host $SSH_HOST not reachable from this environment"
fi

echo "=== Ready to connect: ssh -i $LXC_SSH_KEY_FILE -o StrictHostKeyChecking=no $LXC_SSH_USER@$LXC_SSH_HOST ==="
