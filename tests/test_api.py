from fastapi.testclient import TestClient

from myapp.api import app

client = TestClient(app)


def test_health():
    assert client.get("/health").json() == {"status": "ok"}


# TODO: domain tests (validate echo, fit routes, downloads, UI asserts).
