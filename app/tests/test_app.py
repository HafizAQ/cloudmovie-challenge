import pytest

from src.app import create_app


@pytest.fixture
def app(monkeypatch):

    app = create_app()

    app.config.update(
        TESTING=True,
        SECRET_KEY="test-secret"
    )


    fake_question = {
        "id": "123",
        "clue": "😴 🏙️ 🌀",
        "question": "Which movie is represented by these emojis?",
        "options": [
            "Inception",
            "Avatar",
            "Titanic",
            "Joker",
        ],
        "answer": "Inception",
    }


    monkeypatch.setattr(
        "src.app.get_movie_question",
        lambda: fake_question
    )


    return app



@pytest.fixture
def client(app):

    return app.test_client()



def test_home_page(client):

    response = client.get("/")

    assert response.status_code == 200



def test_game_page(client):

    response = client.get("/game")

    assert response.status_code == 200

    assert b"Guess the Movie" in response.data



def test_correct_answer(client):

    response = client.get("/game")

    response = client.post(
        "/game",
        data={
            "answer": "Inception"
        },
    )


    assert response.status_code == 200

    assert b"Correct" in response.data



def test_incorrect_answer(client):

    response = client.get("/game")


    response = client.post(
        "/game",
        data={
            "answer": "Titanic"
        },
    )


    assert response.status_code == 200

    assert b"Incorrect" in response.data



def test_health_endpoint(client):

    response = client.get("/health")


    assert response.status_code == 200

    assert response.json["status"] == "healthy"

    