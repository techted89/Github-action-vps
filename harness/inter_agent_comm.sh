#!/usr/bin/env bash
# Inter-Agent Communication Script for Projects
# Connects Hermes (agent orchestration) and OpenCode (coding CLI)
# through the Solvr shared room.

set -euo pipefail

ROOM_SLUG="shellular-agent-harness-hermes-opencode"
ROOM_URL="https://solvr.dev/rooms/${ROOM_SLUG}"

# Agent identities
PLANNER="hermes_planner"
EXECUTOR="opencode_executor"
AGENT_KEY_FILE="${HOME}/.solvr/agent_key"

# Secure environment (no embedded secrets)
export GIT_USER="${GIT_USER:-techted89}"
export PAT_TOKEN="${PAT_TOKEN:-}"

echo "+ Inter-agent communication initialized"
echo "+ PLANNER agent: ${PLANNER} (Hermes agent)"
echo "+ EXECUTOR agent: ${EXECUTOR} (OpenCode agent)"
echo "+ Shared room: ${ROOM_URL}"
echo "+ Communication protocol: HTTPS via Solvr API"
echo "+ Security: Environment variables only; no embedded credentials"
echo "+ Project coordination: Agents share room entries for task tracking"
