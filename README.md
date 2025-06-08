 
# 🧠 BACON Codex MCP Bootstrap

This repository provides a standardized **GitHub + OpenAI Codex environment** to kickstart new AI-powered projects using the MCP (Model Context Protocol) pattern.

It is designed to be used as a **template repository**, supporting automated project scaffolding via GitHub + Codex integration.

---

## 🚀 Codex Bootstrap Setup

When this repo is used with OpenAI Codex environments, the setup script will:

1. Dynamically clone the specified GitHub repo
2. Set up Git and authenticate the GitHub CLI (`gh`)
3. Initialize the directory structure:
   - `scripts/`
   - `mcp_templates/`
   - `.github/workflows/`
   - `AGENTS.md`
   - `.env.example`
4. Push any missing scaffolding to the repository (if needed)

---

## ✅ Required Codex Environment Variables

In your [Codex environment setup](https://chatgpt.com/codex/settings/environment), define these variables:

| Variable             | Description                                         |
|----------------------|-----------------------------------------------------|
| `GITHUB_REPO_NAME`   | The name of the GitHub repo, e.g. `my-new-project` |
| `GITHUB_ACCOUNT`     | Your GitHub username (e.g. `thebacons`)            |
| `GITHUB_PAT_KEY`     | Your GitHub **Personal Access Token**              |
| `OPENAI_API_KEY`    | OpenAI API key used by the DocGen agent            |
| `GEMINI_API_KEY`    | Gemini API key (optional)                           |


> 💡 These variables allow one single Codex environment to bootstrap _any_ repo without rebuilding new containers. In production, store them in the Codex environment panel under **Secrets** so they aren't committed to the repository.

 

## 🧪 How to Use This Repo as a Template

1. In GitHub, click **“Use this template”** on the repository homepage  
   → https://github.com/thebacons/bacon-ai-codex-mcp-bootstraps

2. Create a new repo (e.g. `my-next-codex-agent`)

3. In Codex:
   - Use your existing Codex environment (no need to create a new one)
   - Just update the `GITHUB_REPO_NAME` environment variable to your new repo name

4. Codex will auto-clone the repo, authenticate GitHub, and scaffold any missing structure



## 📁 Folder Structure

```bash
.
├── AGENTS.md                # Document for MCP agent definitions and capabilities
├── .env.example             # Example environment file with required variables
├── scripts/
│   └── git_diagnostics.sh   # Debug helper for Git and CI issues
├── mcp_templates/           # Placeholder for MCP agent handler implementations
├── .github/workflows/
│   └── validate-repo.yml    # CI lint to check structure/health
├── README.md                # You’re reading it
``` 

## 🛠️ Script Notes

The Codex environment runs `bootstrap.sh` on startup.
You can find this in your Codex environment settings under **Startup script**.

If needed, revert to your original stable script after initial scaffolding:

```bash
#!/usr/bin/env bash
# See setup_script.sh for full Codex-compatible implementation
```

---

## 📄 License

MIT License – use freely, fork, modify, go wild 🍳
EOF

```


