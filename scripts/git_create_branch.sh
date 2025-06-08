#!/bin/bash
# Ensure GITHUB_PAT_KEY is set
if [ -z "$GITHUB_PAT_KEY" ]; then
    echo "Error: GITHUB_PAT_KEY is missing"
    exit 1
fi

# Authenticate using the PAT key
git remote set-url origin https://thebacons:$GITHUB_PAT_KEY@github.com/thebacons/$GITHUB_REPO_NAME.git

# Create a new branch and push
git checkout -b test-branch-ai-perms
git push origin test-branch-ai-perms

