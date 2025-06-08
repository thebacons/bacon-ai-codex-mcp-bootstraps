from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from pydantic import BaseModel
from typing import Optional, Dict
import os
import openai
import ast
import textwrap
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()

app = FastAPI(title="MCP DocGen Agent")

class CodePayload(BaseModel):
    code: str
    filepath: Optional[str] = None

@app.post("/mcp/generate-doc")
async def generate_docs(payload: CodePayload):
    """
    Parse code and generate docstrings and markdown documentation.

    This is a specialized MCP tool designed for generating code documentation.
    """
    api_key = os.getenv("OPENAI_API_KEY")

    if not api_key:
        raise HTTPException(status_code=500, detail="Missing OPENAI_API_KEY in environment.")

    try:
        tree = ast.parse(payload.code)
    except SyntaxError as exc:
        raise HTTPException(status_code=400, detail=f"Invalid Python code: {exc}")

    docstrings: Dict[str, str] = {}
    markdown_parts = []

    for node in tree.body:
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
            source = ast.get_source_segment(payload.code, node)
            doc_prompt = (
                f"Write a concise docstring for the following Python {type(node).__name__}:\n\n{source}"
            )

            try:
                openai.api_key = api_key
                completion = openai.ChatCompletion.create(
                    model="gpt-4",
                    messages=[{"role": "user", "content": doc_prompt}],
                    temperature=0.2,
                    max_tokens=150,
                )
                doc = completion.choices[0].message["content"].strip()
            except Exception as exc:
                raise HTTPException(status_code=500, detail=str(exc))
        else:
            doc = f"Documentation placeholder for {node.name}."

        docstrings[node.name] = doc
        markdown_parts.append(f"### {node.name}\n\n{doc}\n")

        if ast.get_docstring(node) is None:
            node.body.insert(0, ast.Expr(value=ast.Constant(textwrap.dedent(doc))))

    markdown = "\n".join(markdown_parts)
    docs_dir = Path("docs")
    docs_dir.mkdir(exist_ok=True)
    docs_path = docs_dir / "generated_docs.md"
    docs_path.write_text(markdown)

    if payload.filepath:
        path = Path(payload.filepath)
        if path.is_file():
            path.write_text(ast.unparse(tree))

    # Return MCP-compliant response
    return {"status": "success", "docstrings": docstrings, "markdown": markdown}


@app.get("/.well-known/mcp/manifest.json")
async def serve_manifest():
    """
    Provide the manifest JSON for the MCP server to register and recognize this agent.
    """
    return FileResponse("manifest.json", media_type="application/json")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8080)
