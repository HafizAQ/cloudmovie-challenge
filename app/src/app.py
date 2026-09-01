import random

from flask import Flask, jsonify, render_template, request

from .movie_data import MOVIE_QUESTIONS

from .services.leaderboard_service import LeaderboardService

from src.services.movie_service import get_movie_spotlight

def create_app():
    app = Flask(__name__)

    @app.route("/")
    def home():
        return render_template("index.html")

    @app.route("/game", methods=["GET", "POST"])
    def game():
        if request.method == "POST":
            question_id = request.form.get("question_id")
            selected_answer = request.form.get("answer")

            question = next(
                (
                    item
                    for item in MOVIE_QUESTIONS
                    if item["id"] == question_id
                ),
                None,
            )

            if question is None:
                return (
                    render_template(
                        "game.html",
                        error="Question not found.",
                        question=random.choice(MOVIE_QUESTIONS),
                    ),
                    400,
                )

            is_correct = selected_answer == question["answer"]

            result = (
                "Correct! 🎉"
                if is_correct
                else f"Incorrect. The correct answer was {question['answer']}."
            )

            return render_template(
                "game.html",
                question=random.choice(MOVIE_QUESTIONS),
                result=result,
                is_correct=is_correct,
            )

        question = random.choice(MOVIE_QUESTIONS)

        return render_template(
            "game.html",
            question=question,
        )

    @app.route("/leaderboard", methods=["GET", "POST"])
    def leaderboard():
        service = LeaderboardService()

        if request.method == "POST":
            player = request.form.get(
                "player",
                "",
            ).strip()

            score = request.form.get(
                "score",
                "0",
            ).strip()

            if not player:
                return (
                    render_template(
                        "leaderboard.html",
                        scores=service.get_scores(),
                        error="Player name is required.",
                    ),
                    400,
               )

            try:
                score = int(score)
            except ValueError:
                return (
                    render_template(
                        "leaderboard.html",
                        scores=service.get_scores(),
                        error="Score must be a number.",
                    ),
                    400,
                )

            service.save_score(
              player,
              score,
              )

        scores = service.get_scores()

        return render_template(
            "leaderboard.html",
            scores=scores,
            )

    @app.route("/api/movie-spotlight")
    def movie_spotlight():

        movie = get_movie_spotlight()

        return jsonify(movie)

    @app.route("/health")
    def health():
        return jsonify(
            {
                "status": "healthy",
                "service": "cloudmovie-challenge",
            }
        )

    return app


if __name__ == "__main__":
    create_app().run(
        host="0.0.0.0",
        port=5000,
        debug=True,
    )




# One important architectural choice here is:

# def create_app():

# instead of creating everything globally.

# This is called the application factory pattern. It makes the Flask application easier to:

# test
# configure
# containerize
# run under production servers later
# integrate with different environments

