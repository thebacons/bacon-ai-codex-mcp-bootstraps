#!/bin/bash
set -e

LOG_FILE="setup_test.log"

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

# 3. Ensure the working directory is clean before proceeding
echo "Ensuring working directory is clean..." >> $LOG_FILE
git clean -fdx >> $LOG_FILE
git reset --hard HEAD >> $LOG_FILE

# Check for unstaged changes after cleaning and resetting
if ! git diff-index --quiet HEAD --; then
  echo "Error: There are unstaged changes. Please commit or stash them before proceeding." | tee -a $LOG_FILE
  exit 1
fi

# 4. Clear any existing Git credentials and set the correct remote URL
echo "Clearing existing Git credentials..." >> $LOG_FILE
git credential-cache exit

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

# 5. Attempt to push changes to GitHub
echo "Attempting to push changes to GitHub..." >> $LOG_FILE

# Try to push the changes
git push origin main || {
  echo "Push failed. Attempting with rebase..." >> $LOG_FILE
  git pull --rebase origin main || { echo "Rebase failed. Manual intervention needed." >> $LOG_FILE; exit 1; }
  git push origin main || { echo "Push failed again after rebase. Please check the repository and credentials." >> $LOG_FILE; exit 1; }
}

# Log the successful push
echo "Push successful to GitHub at $(date)" >> $LOG_FILE

# 6. Final verification of the setup and environment
echo "Verifying environment setup..." >> $LOG_FILE
echo "Git remote URL:" >> $LOG_FILE
git remote -v >> $LOG_FILE

echo "Environment setup and Git push process completed successfully." >> $LOG_FILE

# Return the log file path for easy sharing
echo "Log file generated at $(pwd)/$LOG_FILE"
