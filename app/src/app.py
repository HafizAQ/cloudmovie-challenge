import os

from flask import (
    Flask,
    jsonify,
    render_template,
    request,
    session
)

from .services.leaderboard_service import LeaderboardService
from .services.movie_service import (
    get_movie_question,
    get_movie_spotlight
)


def create_app():

    app = Flask(__name__)

    app.secret_key = os.environ.get(
        "SECRET_KEY",
        "cloudmovie-development-key"
    )

    @app.route("/")
    def home():

        return render_template(
            "index.html"
        )

    @app.route("/game", methods=["GET", "POST"])
    def game():

        if request.method == "POST":

            selected_answer = request.form.get(
                "answer"
            )

            question = session.get(
                "question"
            )


            if question is None:

                question = get_movie_question()

                session["question"] = question


            is_correct = (
                selected_answer == question["answer"]
            )


            if is_correct:

                current_score = session.get(
                    "score",
                    0
                )

                session["score"] = current_score + 1

                result = "Correct! 🎉"


            else:

                result = (
                    f"Incorrect ❌ "
                    f"The correct answer was "
                    f"{question['answer']}"
                )


            new_question = get_movie_question()

            session["question"] = new_question


            return render_template(
                "game.html",
                question=new_question,
                result=result,
                is_correct=is_correct,
            )


        # GET request

        question = get_movie_question()

        session["question"] = question


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

    # API endpoint for testing TMDB integration

    @app.route("/api/movie-question")
    def movie_question():

        movie = get_movie_question()

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



# Application Factory Pattern:
#
# def create_app()
#
# Instead of creating Flask globally.
#
# Benefits:
#
# - easier testing
# - easier Docker deployment
# - easier environment configuration
# - works cleanly with Gunicorn
# - supports multiple environments