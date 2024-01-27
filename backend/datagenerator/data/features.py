from backend.models.interest import Interest
from backend.models.language import Language

interests_dict = {
                "sports": Interest(name="sports", icon="icon1"),
                "movies": Interest(name="movies", icon="icon2"),
                "travel": Interest(name="travel", icon="icon3"),
                "books": Interest(name="books", icon="icon4"),
                "science": Interest(name="science", icon="icon5"),
                "music": Interest(name="music", icon="icon6"),
                "art": Interest(name="art", icon="icon7"),
                "food": Interest(name="food", icon="icon8"),
                "technology": Interest(name="technology", icon="icon9"),
                "fashion": Interest(name="fashion", icon="icon10"),
                "photography": Interest(name="photography", icon="icon11"),
                "gaming": Interest(name="gaming", icon="icon12"),
                "nature": Interest(name="nature", icon="icon13"),
                "history": Interest(name="history", icon="icon14"),
                "fitness": Interest(name="fitness", icon="icon15"),
                "crafts": Interest(name="crafts", icon="icon16"),
                "writing": Interest(name="writing", icon="icon17"),
                "gardening": Interest(name="gardening", icon="icon18"),
                "philosophy": Interest(name="philosophy", icon="icon19"),
                "coding": Interest(name="coding", icon="icon20")
            }


language_dict = {
                "english" : Language(name="english"),
                "german": Language(name="german"),
                "french": Language(name="french"),
            }