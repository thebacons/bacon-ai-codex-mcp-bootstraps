#!/bin/bash
set -e

# Ensure required environment variables are set
: "${GITHUB_REPO_NAME:?GITHUB_REPO_NAME is not set}"
: "${GITHUB_ACCOUNT:?GITHUB_ACCOUNT is not set}"

# Configure Git remote using the provided credentials if available
REMOTE_URL="https://github.com/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}.git"
if [ -n "$GITHUB_PAT_KEY" ]; then
  REMOTE_URL="https://${GITHUB_ACCOUNT}:${GITHUB_PAT_KEY}@github.com/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}.git"
else
  echo "Warning: GITHUB_PAT_KEY is not set. Git operations may fail."
fi

if git remote | grep -q '^origin$'; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

echo "Environment setup complete."
