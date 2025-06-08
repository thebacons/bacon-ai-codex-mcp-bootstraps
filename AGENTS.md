
# Codex Agent Documentation

## Purpose

The Codex environment helps automate and streamline GitHub interactions using the provided Personal Access Token (PAT). It ensures that the Git configuration is correct and securely authenticated with the appropriate GitHub account and repository. Additionally, the MCP DocGen agent allows for generating Python docstrings and markdown documentation based on Python code, leveraging OpenAI's GPT models.

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
