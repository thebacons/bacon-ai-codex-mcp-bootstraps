import os
from typing import Optional
from fastapi import FastAPI, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
from dotenv import load_dotenv
import openai

load_dotenv()

app = FastAPI(title="Bacon Blog Inspector")

security = HTTPBearer()

API_TOKEN = os.getenv("BLOG_INSPECTOR_TOKEN")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

class BlogPayload(BaseModel):
    title: str
    content: str


def authenticate(credentials: HTTPAuthorizationCredentials = Depends(security)):
    if API_TOKEN is None:
        raise HTTPException(status_code=500, detail="Server missing BLOG_INSPECTOR_TOKEN")
    if credentials.credentials != API_TOKEN:
        raise HTTPException(status_code=401, detail="Invalid or missing token")


@app.post("/inspect")
async def inspect_blog(payload: BlogPayload, creds: HTTPAuthorizationCredentials = Depends(authenticate)):
    if not OPENAI_API_KEY:
        raise HTTPException(status_code=500, detail="Missing OPENAI_API_KEY")

    prompt = f"Summarize the following blog post and list any potential improvements:\n\nTitle: {payload.title}\n\n{payload.content}"
    try:
        client = openai.OpenAI(api_key=OPENAI_API_KEY)
        completion = client.chat.completions.create(
            model="gpt-4",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.2,
            max_tokens=300,
        )
        response = completion.choices[0].message.content.strip()
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))

    return {"analysis": response}


@app.get("/.well-known/mcp/manifest.json")
async def manifest():
    return {
        "name": "Bacon Blog Inspector",
        "description": "Analyzes blog posts using OpenAI GPT-4 and returns suggestions.",
        "endpoints": ["/inspect"],
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8081)
