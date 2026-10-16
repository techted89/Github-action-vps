#!/usr/bin/env bash
# ==============================================================================
# Authenticated Git & GitHub CLI Setup Script
# Configures Git credentials and authenticates `gh` CLI using PAT.
# ==============================================================================n
set -euo pipefail

# Injected credentials configuration
GIT_USER="techted89"
PAT_TOKEN="${PAT_TOKEN:?ERROR: PAT_TOKEN must be set via secure environment}"

echo "[+] Configuring global Git user identity..."
git config --global user.name "${GIT_USER}"
git config --global user.email "techted89@users.noreply.github.com"

echo "[+] Configuring credential helper storage..."
git config --global credential.helper store

echo "[+] Authenticating GitHub CLI (gh) using provided PAT..."
echo "${PAT_TOKEN}" | gh auth login --with-token || {
    echo "[-] Error: Failed to authenticate GitHub CLI with provided token." >&2
    exit 1
}

echo "[✓] GitHub CLI authentication successful for user: ${GIT_USER}"
gh auth status
