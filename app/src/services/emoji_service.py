import random


KEYWORDS = {

    "space": ["🚀","🌌","🪐"],
    "love": ["❤️","💔","💑"],
    "war": ["⚔️","💣","🪖"],
    "hero": ["🦸","⚡","🔥"],
    "magic": ["🧙","✨","🔮"],
    "ocean": ["🌊","🚢","🐟"],
    "dinosaur": ["🦖","🌴","🚙"],
    "dream": ["😴","🌀","🏙️"],
    "family": ["👨‍👩‍👧","🏠","❤️"],
}


def generate_clue(movie):

    text = (
        movie["title"]
        + " "
        + movie["overview"]
    ).lower()


    emojis=[]


    for keyword, symbols in KEYWORDS.items():

        if keyword in text:
            emojis.extend(symbols)


    if len(emojis)<3:

        emojis.extend(
            random.choice(
                list(KEYWORDS.values())
            )
        )


    return " ".join(emojis[:3])