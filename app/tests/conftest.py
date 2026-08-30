import sys
from pathlib import Path

import pytest


APP_DIRECTORY = Path(__file__).resolve().parents[1]

sys.path.insert(
    0,
    str(APP_DIRECTORY),
)


from src.app import create_app


@pytest.fixture
def app():
    app = create_app()

    app.config.update(
        {
            "TESTING": True,
        }
    )

    yield app


@pytest.fixture
def client(app):
    return app.test_client()