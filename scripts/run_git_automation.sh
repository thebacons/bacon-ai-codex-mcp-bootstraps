#!/bin/bash

# Load environment variables from .env file if present
if [ -f .env ]; then
  echo "Loading environment variables from .env file..."
  export $(grep -v '^#' .env | xargs)
else
  echo "No .env file found. Skipping environment variable load."
fi

# Ensure required environment variables are set
if [ -z "$GITHUB_ACCOUNT" ]; then
  echo "Error: GITHUB_ACCOUNT is not set. Please define it in the environment."
  exit 1
fi

if [ -z "$GITHUB_REPO_NAME" ]; then
  echo "Error: GITHUB_REPO_NAME is not set. Please define it in the environment."
  exit 1
fi

if [ -z "$GITHUB_PAT_KEY" ]; then
  echo "Error: GITHUB_PAT_KEY is not set. Please define it in the environment."
  exit 1
fi

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY is not set. Please define it in the environment."
  exit 1
fi

# Show environment details
echo "GITHUB_ACCOUNT=$GITHUB_ACCOUNT"
echo "GITHUB_REPO_NAME=$GITHUB_REPO_NAME"
echo "GITHUB_PAT_KEY=$GITHUB_PAT_KEY"
echo "OPENAI_API_KEY=$OPENAI_API_KEY"

# Configure Git remote using PAT
REMOTE_URL="https://$GITHUB_ACCOUNT:$GITHUB_PAT_KEY@github.com/$GITHUB_ACCOUNT/$GITHUB_REPO_NAME.git"

echo "Setting Git remote URL to $REMOTE_URL"
git remote set-url origin "$REMOTE_URL" 2>/dev/null || git remote add origin "$REMOTE_URL"

# Verify GitHub authentication
echo "Authenticating to GitHub using the provided PAT..."
STATUS_CODE=$(curl -s -o /tmp/github_user.json -w "%{http_code}" -H "Authorization: token $GITHUB_PAT_KEY" https://api.github.com/user)
if [ "$STATUS_CODE" != "200" ]; then
  echo "Error: Authentication failed with GitHub. Response Code: $STATUS_CODE"
  exit 1
else
  echo "✅ Authentication successful."
fi

# Run branch creation script
if [ -f scripts/git_create_branch.sh ]; then
  echo "Running git_create_branch.sh to create and push a branch..."
  bash scripts/git_create_branch.sh
  if [ $? -eq 0 ]; then
    echo "✅ Branch created and pushed successfully."
  else
    echo "❌ Failed to create or push the branch. Please check the logs for errors."
    exit 1
  fi
else
  echo "Error: scripts/git_create_branch.sh not found."
  exit 1
fi

echo "GitHub integration and branch creation process completed successfully."
