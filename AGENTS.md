
# Codex Agent Documentation

## Purpose

The Codex environment helps automate and streamline GitHub interactions using the provided Personal Access Token (PAT). It ensures that the Git configuration is correct and securely authenticated with the appropriate GitHub account and repository. Additionally, the MCP DocGen agent allows for generating Python docstrings and markdown documentation based on Python code, leveraging OpenAI's GPT models.

Here's an updated section for your **AGENTS.md** to document how to use the new `scripts/run_git_automation.sh` script. You can add this section to the file to ensure clear instructions for Codex and any future users.

---

### **Automated GitHub Branch Creation and Setup**

This guide explains how to use the `scripts/run_git_automation.sh` script to validate environment variables, authenticate with GitHub, and automatically create a test branch in your repository.

#### **Prerequisites**

Before running the script, ensure that the following environment variables are correctly set either in your environment or in the `.env` file:

1. **GITHUB\_ACCOUNT**: Your GitHub username (e.g., `thebacons`).
2. **GITHUB\_REPO\_NAME**: The name of your repository (e.g., `bacon-ai-codex-mcp-bootstraps`).
3. **GITHUB\_PAT\_KEY**: Your GitHub **Personal Access Token (PAT)** with sufficient permissions to push to the repository.
4. **OPENAI\_API\_KEY**: The API key for OpenAI, required for interacting with Codex models.

#### **Script Overview**

The `scripts/run_git_automation.sh` script performs the following tasks:

1. **Environment Variable Validation**:

   * It checks whether the required environment variables (`GITHUB_ACCOUNT`, `GITHUB_REPO_NAME`, `GITHUB_PAT_KEY`, `OPENAI_API_KEY`) are set.
   * If any of these are missing, the script will exit with a clear error message.

2. **GitHub Authentication**:

   * The script authenticates to GitHub using the provided **GITHUB\_PAT\_KEY** by sending a request to the GitHub API.
   * If authentication fails, the script will exit and report an error.

3. **Git Remote Configuration**:

   * It configures the Git remote URL using the provided **GITHUB\_PAT\_KEY** for authentication.
   * If the remote URL is not already set, the script will add it.

4. **Branch Creation and Push**:

   * If the authentication is successful, the script calls `scripts/git_create_branch.sh` to create a new branch (`test-branch-ai-perms`).
   * After creating the branch, the script pushes the branch to GitHub.
   * If any step fails, the script will exit and report an error.

#### **How to Use the Script**

1. Ensure that the required environment variables are set:

   * You can define them in a `.env` file in the root directory or export them directly in your environment.

   Example `.env` file:

   ```bash
   GITHUB_ACCOUNT=your_github_account
   GITHUB_REPO_NAME=your_repo_name
   GITHUB_PAT_KEY=your_github_pat_key
   OPENAI_API_KEY=your_openai_api_key
   ```

2. Run the script:

   ```bash
   bash scripts/run_git_automation.sh
   ```

3. The script will:

   * Validate environment variables.
   * Authenticate to GitHub using the PAT.
   * Set the Git remote URL with the authentication token.
   * Create a new branch called `test-branch-ai-perms` and push it to GitHub.

#### **Script Details**

* **GitHub Authentication**:
  The script uses the **GITHUB\_PAT\_KEY** for authentication via the GitHub API. Ensure that this token has the necessary permissions (repo access).

* **Branch Creation**:
  The script automatically creates and pushes a new branch. If you don't need a branch for testing, modify the script to use an existing branch name.

#### **Common Errors and Troubleshooting**

* **Error: Missing Environment Variables**:
  The script checks for the presence of the following variables: `GITHUB_ACCOUNT`, `GITHUB_REPO_NAME`, `GITHUB_PAT_KEY`, and `OPENAI_API_KEY`. If any are missing, the script will stop and provide an error message.

* **Error: Authentication Failed**:
  If the GitHub API returns a `401` status, verify that the **GITHUB\_PAT\_KEY** is correct and has the appropriate permissions.

* **Error: Branch Creation Fails**:
  If the branch cannot be created or pushed, check the Git configuration and permissions in the repository.

---

This section should help Codex and users to easily set up the environment and use the automation script.

## MCP DocGen Agent

The **MCP DocGen agent** is designed to generate Python docstrings and markdown documentation for code files. It uses OpenAI's GPT model to analyze Python code and produce structured documentation, both inline as docstrings and as markdown files.

### Setup Instructions

1. **Environment Variables**:
   Ensure the following environment variables are set before running any scripts:

   * `GITHUB_REPO_NAME`: The name of the repository (e.g., `thebacons-demo-gdocs-mcp`).
   * `GITHUB_ACCOUNT`: Your GitHub username (e.g., `thebacons`).
   * `GITHUB_PAT_KEY`: Your GitHub Personal Access Token with sufficient permissions to push to the repository.
   * `OPENAI_API_KEY`: The API key for OpenAI, required to interact with GPT models for generating docstrings.

   If any of these variables are missing, the script will fail with a clear error message. For local development, you can use a `.env` file to define them.

2. **Dependencies**:

   * **FastAPI** must be installed to run the server.
   * **OpenAI** Python SDK is required to interact with the OpenAI API for generating documentation.
   * **GitHub CLI** (`gh`) must be installed on the system to interact with GitHub and fetch repository variables.
   * Install dependencies by running:

     ```bash
     pip install -r requirements.txt
     ```

3. **API Key Configuration**:
   The **OPENAI\_API\_KEY** should be set either through a `.env` file or as an environment variable. If you're working in **Codex**, ensure the key is correctly configured before starting the server.

4. **Server Configuration**:
   The **MCP DocGen agent** runs as a **FastAPI** app, exposing two main endpoints:

   * `/generate-doc`: Accepts Python code as input, generates docstrings for functions/classes, and outputs markdown documentation.
   * `/manifest.json`: Serves the manifest file, describing the capabilities of the MCP server.

   The server runs on port 8080 by default. If running in Codex, ensure the server is accessible via the network.

### Example Environment Setup

You can set up the environment in one of the following ways:

1. **Using a `.env` File**:
   Ensure that the `.env` file exists in the root of the project and contains the following variables:

   ```bash
   GITHUB_ACCOUNT=your_github_account
   GITHUB_REPO_NAME=your_repo_name
   GITHUB_PAT_KEY=your_github_pat_key
   OPENAI_API_KEY=your_openai_api_key
   ```

2. **Using Environment Variables**:
   Alternatively, you can set these variables directly in the environment:

   ```bash
   export GITHUB_ACCOUNT=your_github_account
   export GITHUB_REPO_NAME=your_repo_name
   export GITHUB_PAT_KEY=your_github_pat_key
   export OPENAI_API_KEY=your_openai_api_key
   ```

---

This documentation update will provide clarity on how to configure the **MCP DocGen agent** and integrate it with Codex, ensuring it works with the required environment variables.

If you need further adjustments or specific information, let me know!
