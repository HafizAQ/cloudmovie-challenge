import pytest

from src.app import create_app


FAKE_QUESTION = {
    "id": "123",
    "clue": "🚢 ❤️ 🧊",
    "question": "Which movie is represented by these emojis?",
    "options": [
        "Titanic",
        "Avatar",
        "Jaws",
        "Matrix",
    ],
    "answer": "Titanic",
}


@pytest.fixture
def app(monkeypatch):

    monkeypatch.setattr(
        "src.app.get_movie_question",
        lambda: FAKE_QUESTION.copy(),
    )

    app = create_app()

    app.config.update(
        TESTING=True,
        SECRET_KEY="test-secret",
    )

    return app


@pytest.fixture
def client(app):

    return app.test_client()


def test_home_page(client):

    response = client.get("/")

    assert response.status_code == 200
    assert b"CloudMovie Challenge" in response.data


def test_game_page(client):

    response = client.get("/game")

    assert response.status_code == 200

    assert b"Guess the Movie" in response.data

    assert b"Titanic" in response.data
    assert b"Avatar" in response.data
    assert b"Jaws" in response.data
    assert b"Matrix" in response.data


def test_correct_answer(client):

    # Creates the active question in session
    response = client.get("/game")

    assert response.status_code == 200

    # Titanic is the mocked correct answer
    response = client.post(
        "/game",
        data={
            "answer": "Titanic",
        },
    )

    assert response.status_code == 200

    assert b"Correct" in response.data

    # Correct answer should increase score
    with client.session_transaction() as session:
        assert session.get("score") == 1


def test_incorrect_answer(client):

    # Creates the active question in session
    response = client.get("/game")

    assert response.status_code == 200

    # Avatar is deliberately incorrect
    response = client.post(
        "/game",
        data={
            "answer": "Avatar",
        },
    )

    assert response.status_code == 200

    assert b"Incorrect" in response.data

    # Incorrect answer should not increase score
    with client.session_transaction() as session:
        assert session.get("score", 0) == 0


def test_health_endpoint(client):

    response = client.get("/health")

    assert response.status_code == 200

    assert response.get_json() == {
        "status": "healthy",
        "service": "cloudmovie-challenge",
    }