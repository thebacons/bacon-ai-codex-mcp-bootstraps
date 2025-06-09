import os
import sys
from pathlib import Path
import pytest
import httpx

os.environ['BLOG_INSPECTOR_TOKEN'] = 'testtoken'
os.environ['OPENAI_API_KEY'] = 'dummy'

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from blog_inspector.main import app

class DummyChoice:
    def __init__(self, content):
        self.message = type('obj', (), {'content': content})

class DummyCompletion:
    def __init__(self, text):
        self.choices = [DummyChoice(text)]

@pytest.mark.asyncio
async def test_inspect_blog(monkeypatch):
    def fake_create(**kwargs):
        return DummyCompletion('Analysis result')

    monkeypatch.setattr('openai.OpenAI', lambda api_key=None: type('C', (), {
        'chat': type('CC', (), {
            'completions': type('CC2', (), {
                'create': staticmethod(fake_create)
            })()
        })()
    }))

    transport = httpx.ASGITransport(app=app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as ac:
        resp = await ac.post('/inspect', json={'title': 't', 'content': 'c'}, headers={'Authorization': 'Bearer testtoken'})
    assert resp.status_code == 200
    assert resp.json()['analysis'] == 'Analysis result'
