# MCP DocGen Agent

This agent exposes a `/generate-doc` endpoint that accepts Python code and returns generated docstrings and Markdown documentation. Results are also saved to `docs/generated_docs.md`.

## Setup

```bash
pip install -r requirements.txt
```

## Running Locally

```bash
bash ../../scripts/launch_docgen_agent.sh
```

The service runs on `http://localhost:8080`. In another terminal:

```bash
python ../../scripts/call_docgen_agent.py
```

### Endpoint

```
POST http://localhost:8080/generate-doc
Content-Type: application/json

{"code": "def foo():\n    pass"}
```

## MCP Registration

Serve the agent and use the manifest available at `/.well-known/mcp/manifest.json` to register with an MCP controller.
