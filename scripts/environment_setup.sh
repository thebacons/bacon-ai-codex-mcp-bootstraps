#!/bin/bash
set -e

# Ensure required environment variables are set
: "${GITHUB_REPO_NAME:?GITHUB_REPO_NAME is not set. Please define it in the environment variables or .env file.}"
: "${GITHUB_ACCOUNT:?GITHUB_ACCOUNT is not set. Please define it in the environment variables or .env file.}"
: "${GITHUB_PAT_KEY:?GITHUB_PAT_KEY is not set. Please define it in the environment variables or .env file.}"

# Check if required tools are available (e.g., GitHub CLI)
command -v gh >/dev/null 2>&1 || { echo "GitHub CLI (gh) is not installed. Please install it first."; exit 1; }

# Configure Git remote using the provided credentials if available
REMOTE_URL="https://github.com/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}.git"
if [ -n "$GITHUB_PAT_KEY" ]; then
  REMOTE_URL="https://${GITHUB_ACCOUNT}:${GITHUB_PAT_KEY}@github.com/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}.git"
else
  echo "Warning: GITHUB_PAT_KEY is not set. Git operations may fail."
fi

# Set the Git remote
if git remote | grep -q '^origin$'; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# Compare the PAT in the remote URL with the provided environment variable
remote_token="$(git remote get-url origin | sed -E 's|https://[^:]+:([^@]+)@.*|\1|')"
if [ -n "$remote_token" ] && [ -n "$GITHUB_PAT_KEY" ]; then
  if [ "$remote_token" = "$GITHUB_PAT_KEY" ]; then
    echo "PAT in remote matches provided token."
  else
    echo "Warning: PAT in remote does not match provided token."
  fi
fi

echo "Environment setup complete."
