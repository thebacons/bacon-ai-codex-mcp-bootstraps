# Codex Agent Documentation

## Purpose
The Codex environment helps automate and streamline GitHub interactions using the provided Personal Access Token (PAT). It ensures that the Git configuration is correct and securely authenticated with the appropriate GitHub account and repository.

## Setup Instructions
1. **Environment Variables**:
   Ensure the following environment variables are set before running any scripts:
   - `GITHUB_REPO_NAME`: The name of the repository (e.g., `thebacons-demo-gdocs-mcp`).
   - `GITHUB_ACCOUNT`: Your GitHub username (e.g., `thebacons`).
   - `GITHUB_PAT_KEY`: Your GitHub Personal Access Token with sufficient permissions to push to the repository.

   If any of these variables are missing, the script will fail with a clear error message. For local development, you can use a `.env` file to define them.

2. **Dependencies**:
   - GitHub CLI (`gh`) must be installed on the system to interact with GitHub and fetch repository variables.
   - Install dependencies by running `pip install -r requirements.txt`.

## Example Environment Setup
You can set up the environment in one of the following ways:
1. **Using a `.env` File**: 
   Ensure that the `.env` file exists in the root of the project and contains the following variables:
   ```bash
   GITHUB_ACCOUNT=your_github_account
   GITHUB_REPO_NAME=your_repo_name
   GITHUB_PAT_KEY=your_github_pat_key
