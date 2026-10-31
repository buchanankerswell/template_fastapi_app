"""FastAPI tier. Browsers and agents read the same endpoints."""

from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

# TODO: domain models (see STANDARDS.md §3: keep data models domain-specific).

app = FastAPI(
    title="myapp",
    version="1.0.0",
    description="Agent-facing JSON API. Humans: use the web UI served at /.",
)
app.mount("/static", StaticFiles(directory=Path(__file__).parent / "static"), name="static")


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


# TODO: domain routes (GET reads, POST /validate echo, POST /fit* compute,
# one download route) + GET / + tab route serving static/index.html.


def main() -> None:
    import uvicorn

    uvicorn.run("myapp.api:app", host="127.0.0.1", port=8000, reload=True)


if __name__ == "__main__":
    main()
