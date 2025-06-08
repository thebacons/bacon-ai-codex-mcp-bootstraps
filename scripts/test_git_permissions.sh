#!/bin/bash 
set -e

# Check if the required environment variables are set
if [ -z "$GITHUB_ACCOUNT" ]; then
    echo "Error: GITHUB_ACCOUNT is not set."
    exit 1
fi

if [ -z "$GITHUB_REPO_NAME" ]; then
    echo "Error: GITHUB_REPO_NAME is not set."
    exit 1
fi

if [ -z "$GITHUB_PAT_KEY" ]; then
    echo "Error: GITHUB_PAT_KEY is not set."
    exit 1
fi

echo "---- GIT ENVIRONMENT DIAGNOSTIC ----"
echo "User: $(whoami)"
echo "Current directory: $(pwd)"
git --version
git config user.name || echo "Not set"
git config user.email || echo "Not set"
git remote -v
git branch -vv

# Test GitHub authentication using the provided PAT
echo "Testing GitHub authentication..."
curl -H "Authorization: token $GITHUB_PAT_KEY" https://api.github.com/user

# Create a local test branch for permission testing
echo "Creating local test branch: 'test-branch-ai-perms'"
git checkout -b test-branch-ai-perms

# Make sure we're back to the main branch
git checkout main || git checkout -b main

# Clean up the test branch
git branch -D test-branch-ai-perms

# Dry run the push to check permissions
git push --dry-run origin main

echo "---- END OF TEST ----"
"
