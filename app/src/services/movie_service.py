import random
import requests

from .secrets_service import get_tmdb_token


TMDB_URL = (
    "https://api.themoviedb.org/3/movie/top_rated"
)


def generate_emoji_clue(movie):
    """
    Creates a simple emoji clue from movie metadata.

    For the capstone this intentionally stays simple.
    A production version could use AI/NLP
    or a dedicated metadata-to-emoji model.
    """

    title = movie["title"].lower()

    emoji_map = {
        "titanic": "🚢 ❤️ 🧊",
        "inception": "😴 🏙️ 🌀",
        "jurassic": "🦖 🏝️ 🚙",
        "lord": "🧙 💍 🌋",
        "ring": "💍 🌋 🧙",
        "avatar": "🌌 👽 🌿",
        "matrix": "💻 🕶️ 🔴",
        "joker": "🃏 🏙️ 😈",
        "batman": "🦇 🌃 🦸",
        "star wars": "🚀 🌌 ⚔️",
    }


    for keyword, emoji in emoji_map.items():

        if keyword in title:
            return emoji


    # Generic fallback
    return "🎬 ⭐ 🎭"



def generate_wrong_answers(correct_movie, movies):

    titles = [
        movie["title"]
        for movie in movies
        if movie["title"] != correct_movie
    ]


    wrong_answers = random.sample(
        titles,
        min(3, len(titles))
    )


    return wrong_answers



def get_movie_question():

    token = get_tmdb_token()


    response = requests.get(
        TMDB_URL,
        headers={
            "Authorization": f"Bearer {token}",
            "accept": "application/json",
        },
        params={
            "language": "en-US",
            "page": 1,
        },
        timeout=5,
    )


    response.raise_for_status()


    movies = response.json()["results"]


    selected_movie = random.choice(
        movies
    )


    correct_answer = selected_movie["title"]


    wrong_answers = generate_wrong_answers(
        correct_answer,
        movies,
    )


    options = (
        wrong_answers
        + [correct_answer]
    )


    random.shuffle(options)


    return {

        "id": str(
            selected_movie["id"]
        ),

        "clue": generate_emoji_clue(
            selected_movie
        ),

        "question": (
            "Which movie is represented "
            "by these emojis?"
        ),

        "options": options,

        "answer": correct_answer,

    }
