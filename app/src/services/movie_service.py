import random
import requests

from .secrets_service import get_tmdb_token


TMDB_URL = (
    "https://api.themoviedb.org/3/movie/top_rated"
)


EMOJI_LIBRARY = [
    "🎬 ⭐ 🎭",
    "🚀 🌌 👽",
    "❤️ 💔 🎵",
    "🦖 🌴 🚙",
    "🧙 💍 🌋",
    "🕵️ 🔫 🏙️",
    "😂 👨‍👩‍👧",
    "👻 🏚️ 😱",
]


def get_tmdb_movies():

    token = get_tmdb_token()

    response = requests.get(
        TMDB_URL,
        headers={
            "Authorization": f"Bearer {token}",
            "accept": "application/json",
        },
        params={
            "language": "en-US",
            "page": random.randint(1,5)
        },
        timeout=5,
    )

    response.raise_for_status()

    return response.json()["results"]



def create_options(correct_movie, movies):

    titles = [
        movie["title"]
        for movie in movies
        if movie["title"] != correct_movie["title"]
    ]

    wrong_answers = random.sample(
        titles,
        3
    )

    options = (
        wrong_answers +
        [correct_movie["title"]]
    )

    random.shuffle(options)

    return options



def get_movie_question():

    movies = get_tmdb_movies()


    movie = random.choice(
        movies
    )


    return {

        "id": str(movie["id"]),

        "clue": random.choice(
            EMOJI_LIBRARY
        ),

        "question":
        "Which movie is represented by these emojis?",

        "options":
        create_options(
            movie,
            movies
        ),

        "answer":
        movie["title"],

    }



def get_movie_spotlight():

    movie = random.choice(
        get_tmdb_movies()
    )


    return {

        "title":
        movie["title"],

        "overview":
        movie["overview"],

        "rating":
        movie["vote_average"],

        "release_date":
        movie.get(
            "release_date"
        )

    }