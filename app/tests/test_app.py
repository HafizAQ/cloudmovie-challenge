def test_home_page(client):
    response = client.get("/")

    assert response.status_code == 200
    assert b"CloudMovie Challenge" in response.data


def test_game_page(client):
    response = client.get("/game")

    assert response.status_code == 200
    assert b"Guess the Movie" in response.data


def test_leaderboard_page(client):
    response = client.get("/leaderboard")

    assert response.status_code == 200
    assert b"Leaderboard" in response.data
    assert b"Alex" in response.data


def test_health_endpoint(client):
    response = client.get("/health")

    assert response.status_code == 200

    data = response.get_json()

    assert data["status"] == "healthy"
    assert data["service"] == "cloudmovie-challenge"


def test_correct_answer(client):
    response = client.post(
        "/game",
        data={
            "question_id": "inception",
            "answer": "Inception",
        },
    )

    assert response.status_code == 200
    assert b"Correct!" in response.data


def test_incorrect_answer(client):
    response = client.post(
        "/game",
        data={
            "question_id": "inception",
            "answer": "Titanic",
        },
    )

    assert response.status_code == 200
    assert b"Incorrect" in response.data
    assert b"Inception" in response.data


def test_invalid_question(client):
    response = client.post(
        "/game",
        data={
            "question_id": "does-not-exist",
            "answer": "Something",
        },
    )

    assert response.status_code == 400
    assert b"Question not found" in response.data


#seven tests
#This test will automatically check on CI (continuous integration) before deployment (real DevOps)

