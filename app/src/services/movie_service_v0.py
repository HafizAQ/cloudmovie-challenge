import random
import requests

from .secrets_service import get_tmdb_token


TMDB_URL = (
    "https://api.themoviedb.org/3/movie/top_rated"
)


def get_movie_spotlight():

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


    movie = random.choice(movies)


    return {

        "title": movie["title"],

        "overview": movie["overview"],

        "rating": movie["vote_average"],

        "release_date": movie.get(
            "release_date"
        ),

    }