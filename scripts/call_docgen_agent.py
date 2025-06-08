import json
import urllib.request

payload_path = 'mcp_templates/mcp-docgen-agent/examples/test_payload.json'
with open(payload_path, 'r') as f:
    data = json.load(f)

req = urllib.request.Request(
    'http://localhost:8080/generate-doc',
    data=json.dumps(data).encode('utf-8'),
    headers={'Content-Type': 'application/json'},
    method='POST'
)

with urllib.request.urlopen(req) as resp:
    body = resp.read().decode('utf-8')
    print(body)
