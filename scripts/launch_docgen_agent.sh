#!/bin/bash
# Launch the DocGen agent using uvicorn
uvicorn main:app --app-dir mcp_templates/mcp-docgen-agent --host 0.0.0.0 --port 8080
