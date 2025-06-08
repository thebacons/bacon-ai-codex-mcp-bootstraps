#!/bin/bash
set -e

LOG_FILE="setup_test.log"

# Ensure a clean working directory before running the script
echo "Ensuring working directory is clean..." >> $LOG_FILE

# Stash any changes (including untracked files)
echo "Stashing all changes before setup..." >> $LOG_FILE
git add -A
git commit -m "Saving changes before setup" || echo "No changes to commit, moving forward..." >> $LOG_FILE
git stash push -m "Stashing all changes before setup" --include-untracked

# Create or clear the log file
echo "Starting setup and test at $(date)" > $LOG_FILE

# 1. Load environment variables from .env file if present
if [ -f .env ]; then
  echo "Loading environment variables from .env file..." >> $LOG_FILE
  export $(grep -v '^#' .env | xargs) >> $LOG_FILE
else
  echo "No .env file found, skipping environment variable load." >> $LOG_FILE
fi

# 2. Check if required environment variables are set
echo "Checking environment variables..." >> $LOG_FILE

echo "GITHUB_ACCOUNT=$GITHUB_ACCOUNT" >> $LOG_FILE
echo "GITHUB_REPO_NAME=$GITHUB_REPO_NAME" >> $LOG_FILE
echo "GITHUB_PAT_KEY=$GITHUB_PAT_KEY" >> $LOG_FILE
echo "OPENAI_API_KEY=$OPENAI_API_KEY" >> $LOG_FILE

if [ -z "$GITHUB_ACCOUNT" ]; then
  echo "Error: GITHUB_ACCOUNT is not set. Please define it in the environment." | tee -a $LOG_FILE
  exit 1
fi

if [ -z "$GITHUB_REPO_NAME" ]; then
  echo "Error: GITHUB_REPO_NAME is not set. Please define it in the environment." | tee -a $LOG_FILE
  exit 1
fi

if [ -z "$GITHUB_PAT_KEY" ]; then
  echo "Error: GITHUB_PAT_KEY is not set. Please define it in the environment." | tee -a $LOG_FILE
  exit 1
fi

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY is not set. Please define it in the environment." | tee -a $LOG_FILE
  exit 1
fi

echo "Environment variables are set." >> $LOG_FILE

# 3. Check for unstaged changes
if ! git diff-index --quiet HEAD --; then
  echo "Error: There are unstaged changes. Please commit or stash them before proceeding." | tee -a $LOG_FILE
  exit 1
fi

# 4. Configure Git remote using the provided credentials
echo "Configuring Git remote..." >> $LOG_FILE
REMOTE_URL="https://github.com/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}.git"

if [ -n "$GITHUB_PAT_KEY" ]; then
  # Use the PAT directly in the URL for authentication
  REMOTE_URL="https://${GITHUB_ACCOUNT}:${GITHUB_PAT_KEY}@github.com/${GITHUB_ACCOUNT}/${GITHUB_REPO_NAME}.git"
  echo "Using provided GITHUB_PAT_KEY for remote authentication." >> $LOG_FILE
else
  echo "Warning: GITHUB_PAT_KEY is not set. Git operations may fail." >> $LOG_FILE
fi

# Set the Git remote URL
echo "Using remote URL: $REMOTE_URL" >> $LOG_FILE
if git remote | grep -q '^origin$'; then
  echo "Updating Git remote URL..." >> $LOG_FILE
  git remote set-url origin "$REMOTE_URL"
else
  echo "Adding Git remote URL..." >> $LOG_FILE
  git remote add origin "$REMOTE_URL"
fi

# 5. Compare the PAT in the remote URL with the provided environment variable
echo "Comparing remote token with GITHUB_PAT_KEY..." >> $LOG_FILE
remote_token="$(git remote get-url origin | sed -E 's|https://[^:]+:([^@]+)@.*|\1|')"
if [ -n "$remote_token" ] && [ -n "$GITHUB_PAT_KEY" ]; then
  if [ "$remote_token" = "$GITHUB_PAT_KEY" ]; then
    echo "PAT in remote matches provided token." >> $LOG_FILE
  else
    echo "Warning: PAT in remote does not match provided token." >> $LOG_FILE
  fi
fi

# 6. Attempt to push changes to GitHub
echo "Attempting to push changes to GitHub..." >> $LOG_FILE

# Try to push the changes
git push origin main || {
  echo "Push failed. Attempting with rebase..." >> $LOG_FILE
  git pull --rebase origin main || { echo "Rebase failed. Manual intervention needed." >> $LOG_FILE; exit 1; }
  git push origin main || { echo "Push failed again after rebase. Please check the repository and credentials." >> $LOG_FILE; exit 1; }
}

# Log the successful push
echo "Push successful to GitHub at $(date)" >> $LOG_FILE

# 7. Final verification of the setup and environment
echo "Verifying environment setup..." >> $LOG_FILE
echo "Git remote URL:" >> $LOG_FILE
git remote -v >> $LOG_FILE

echo "Environment setup and Git push process completed successfully." >> $LOG_FILE

# Restore the stashed changes (if any)
git stash pop || echo "No stashed changes to restore."

# Return the log file path for easy sharing
echo "Log file generated at $(pwd)/$LOG_FILE"
