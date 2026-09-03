import json
import os
import random
import urllib.parse
import urllib.request

import boto3


TMDB_URL = "https://api.themoviedb.org/3/movie/popular"

GENRE_EMOJIS = {
    28: "💥",      # Action
    12: "🗺️",      # Adventure
    16: "🎨",      # Animation
    35: "😂",      # Comedy
    80: "🕵️",      # Crime
    18: "🎭",      # Drama
    10751: "👨‍👩‍👧",  # Family
    14: "🧙",      # Fantasy
    27: "👻",      # Horror
    9648: "🔍",    # Mystery
    10749: "❤️",   # Romance
    878: "🚀",     # Science Fiction
    53: "😱",      # Thriller
    10752: "⚔️",   # War
}


def get_tmdb_token():
    client = boto3.client("secretsmanager")

    response = client.get_secret_value(
        SecretId=os.environ["TMDB_SECRET_ID"]
    )

    secret = json.loads(response["SecretString"])

    return secret["TMDB_API_TOKEN"]


def fetch_movies(token):
    query = urllib.parse.urlencode(
        {
            "language": "en-US",
            "page": 1,
        }
    )

    request = urllib.request.Request(
        f"{TMDB_URL}?{query}",
        headers={
            "Authorization": f"Bearer {token}",
            "accept": "application/json",
        },
    )

    with urllib.request.urlopen(
        request,
        timeout=5,
    ) as response:
        return json.loads(
            response.read().decode("utf-8")
        )["results"]


def generate_clue(movie):
    emojis = [
        GENRE_EMOJIS[genre_id]
        for genre_id in movie.get("genre_ids", [])
        if genre_id in GENRE_EMOJIS
    ]

    while len(emojis) < 3:
        emojis.append("🎬")

    return " ".join(emojis[:3])


def handler(event, context):
    token = get_tmdb_token()

    movies = fetch_movies(token)

    selected = random.choice(movies)

    other_titles = [
        movie["title"]
        for movie in movies
        if movie["id"] != selected["id"]
    ]

    options = random.sample(
        other_titles,
        3,
    )

    options.append(selected["title"])

    random.shuffle(options)

    challenge = {
        "clue": generate_clue(selected),
        "question": "Bonus Challenge: Guess the movie",
        "options": options,
        "answer": selected["title"],
    }

    print(
        json.dumps(
            {
                "event": "bonus_challenge_generated",
                "movie_id": selected["id"],
            }
        )
    )

    return challenge