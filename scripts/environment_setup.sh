#!/bin/bash
set -e

# Ensure required environment variables are set
: "${GITHUB_REPO_NAME:?GITHUB_REPO_NAME is not set}"
: "${GITHUB_ACCOUNT:?GITHUB_ACCOUNT is not set}"
: "${GITHUB_PAT_KEY:?GITHUB_PAT_KEY is not set}"

# Configure Git remote using the provided credentials
git remote set-url origin "https://${GITHUB_ACCOUNT}:${GITHUB_PAT_KEY}@github.com/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}.git"

echo "Git remote URL successfully set for ${GITHUB_REPO_NAME}."
