from datetime import datetime, timedelta
from sqlalchemy.engine import Engine
from sqlmodel import Session, select
from backend.models.conversation import Conversation
from backend.models.gender_identity import GenderIdentity
from backend.models.image import ProfilePicture
from backend.models.interest import Interest
from backend.models.language import Language
import os
from dotenv import load_dotenv
from backend.services.profile_picture import post_profile_picture
from backend.models.preference import Preference
from backend.models.expert_system import ExpertSystem
from backend.models.rating import Rating
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.utils.passwords import hash_pwd
from backend.datagenerator.data.features import interests_dict, language_dict
from backend.datagenerator.data.exsys_training_data import exsys_trainings_data
from backend.algo.exsys import ExSys
load_dotenv()

def calculate_birthdate(age):
    current_date = datetime.now()
    birthdate = current_date - timedelta(days=365 * age)
    return birthdate


class DataGenerator:
    def __init__(self, engine: Engine):
        self.engine = engine

    def generate_data(self):
        with Session(self.engine) as session:
            if len(session.exec(select(Language)).all()) == 0 and len(session.exec(select(Language)).all()) == 0:
                print("Generating data")
                self.__generate_users()
            else:
                print("Data already generated")

    # TODO: Modularize Languages, Preferences etc.
    def __generate_users(self):
        with Session(self.engine) as session:


            sports= Interest(name="sports", icon="icon1")
            movies= Interest(name="movies", icon="icon2")
            travel= Interest(name="travel", icon="icon3")
            books= Interest(name="books", icon="icon4")
            science= Interest(name="science", icon="icon5")
            music= Interest(name="music", icon="icon6")
            art= Interest(name="art", icon="icon7")
            food= Interest(name="food", icon="icon8")
            technology= Interest(name="technology", icon="icon9")
            fashion= Interest(name="fashion", icon="icon10")
            photography= Interest(name="photography", icon="icon11")
            gaming= Interest(name="gaming", icon="icon12")
            nature= Interest(name="nature", icon="icon13")
            history= Interest(name="history", icon="icon14")
            fitness= Interest(name="fitness", icon="icon15")
            crafts= Interest(name="crafts", icon="icon16")
            writing= Interest(name="writing", icon="icon17")
            gardening= Interest(name="gardening", icon="icon18")
            philosophy= Interest(name="philosophy", icon="icon19")
            coding= Interest(name="coding", icon="icon20")


            # Preferences
            preference_1: Preference = Preference(property_1="property1", property_2="property4", decision="decision1",
                                                  date=datetime.today())
            preference_2: Preference = Preference(property_1="property2", property_2="property5", decision="decision2",
                                                  date=datetime.today())

            # Gender Identity
            man = GenderIdentity(name="man")
            woman = GenderIdentity(name="woman")
            divers = GenderIdentity(name="divers")

            # TODO Delete when we train through frontend
            # Expert System
            expert_system = ExSys(None)

            # Create training data
            X_train = []

            # Target Data
            y_train = []

            # Add training user data
            for user in exsys_trainings_data:
                actual_user = exsys_trainings_data.get(user)
                X_train.append([
                    actual_user["age"],
                    actual_user["biolenght"],
                    actual_user["genderid"],
                    actual_user["sports"],
                    actual_user["movies"],
                    actual_user["travel"],
                    actual_user["books"],
                    actual_user["science"],
                    actual_user["music"],
                    actual_user["art"],
                    actual_user["food"],
                    actual_user["technology"],
                    actual_user["fashion"],
                    actual_user["photography"],
                    actual_user["gaming"],
                    actual_user["nature"],
                    actual_user["history"],
                    actual_user["fitness"],
                    actual_user["crafts"],
                    actual_user["writing"],
                    actual_user["gardening"],
                    actual_user["philosophy"],
                    actual_user["coding"]
                ])
                y_train.append(actual_user["liked"])

            expert_system.train_model_with_fixed_training_data(X_train, y_train)

            serialized_model = expert_system.serialize_model()

            # Users
            user_alfa = User(
                first_name='Alfa',
                last_name='Alfonson',
                email='alfa.alfonson@email.com',
                bio="Test subject with a passion for sports and adventure.",
                date_of_birth=calculate_birthdate(43),
                job='Software Engineer',
                search_radius=20000,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english")],
                preferences=[preference_1],
                gender_preferences=[woman],
                gender_identity=man,
                interests=[sports, movies, travel],
                password=hash_pwd("pass1"),
                latitude=48.227982,
                longitude=16.372316
            )
            session.add(user_alfa)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=1,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_bravo = User(
                first_name='Bravo',
                last_name='Bravonson',
                email='bravo.bravonson@email.com',
                bio="Exploring the world one movie at a time. Movie buff and aspiring filmmaker.",
                date_of_birth=calculate_birthdate(19),
                job='Data Scientist',
                search_radius=50,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("french"), language_dict.get("german")],
                preferences=[preference_1, preference_2],
                gender_preferences=[woman, man],
                gender_identity=woman,
                interests=[travel, books, science],
                password=hash_pwd("pass1"),
                latitude=48.215178,
                longitude=16.354447
            )
            session.add(user_bravo)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=2,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_charlie = User(
                first_name='Charlie',
                last_name='Charlieson',
                email='charlie.charlieson@email.com',
                bio="Wanderlust-infected travel enthusiast. Let's explore together!",
                date_of_birth=calculate_birthdate(25),
                job='Civil Engineer',
                search_radius=20,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("french"), language_dict.get("german")],
                gender_preferences=[woman],
                preferences=[preference_2],
                gender_identity=divers,
                interests=[science, sports, books],
                password=hash_pwd("pass1"),
                latitude=48.172097,
                longitude=16.294326
            )
            session.add(user_charlie)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=3,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_delta = User(
                first_name='Delta',
                last_name='Deltason',
                email='delta.deltason@email.com',
                bio="Bookworm by day, stargazer by night. Constantly lost in the world of words.",
                date_of_birth=calculate_birthdate(24),
                job='Graphic Designer',
                search_radius=30,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_2],
                gender_preferences=[man],
                gender_identity=man,
                interests=[music, art, technology],
                password=hash_pwd("pass1"),
                latitude=48.208174,
                longitude=16.373819
            )
            session.add(user_delta)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=4,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_echo = User(
                first_name='Echo',
                last_name='Echoson',
                email='echo.echoson@email.com',
                bio="Science geek with a love for experiments and discovery.",
                date_of_birth=calculate_birthdate(28),
                job='Marketing Specialist',
                search_radius=40,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("french")],
                preferences=[preference_1, preference_2],
                gender_preferences=[woman, man],
                gender_identity=woman,
                interests=[food, fashion, photography, movies],
                password=hash_pwd("pass1"),
                latitude=48.200519,
                longitude=16.369796
            )
            session.add(user_echo)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=5,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_foxtrot = User(
                first_name='Foxtrot',
                last_name='Foxtrotson',
                email='foxtrot.foxtrotson@email.com',
                bio="Melodies and rhythms define my world. Music is my soul language.",
                date_of_birth=calculate_birthdate(30),
                job='Architect',
                search_radius=25,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("german")],
                preferences=[preference_1],
                gender_preferences=[woman],
                gender_identity=divers,
                interests=[nature, history, fitness],
                password=hash_pwd("pass1"),
                latitude=48.213185,
                longitude=16.377086
            )
            session.add(user_foxtrot)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=6,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_golf = User(
                first_name='Golf',
                last_name='Golfson',
                email='golf.golfson@email.com',
                bio="Creating art that speaks louder than words. Painter and dreamer.",
                date_of_birth=calculate_birthdate(29),
                job='Professional Golfer',
                search_radius=15,
                matching_algorithm=2,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english")],
                preferences=[preference_1],
                gender_preferences=[man],
                gender_identity=man,
                interests=[sports, travel, movies],
                password=hash_pwd("pass1"),
                latitude=48.225241,
                longitude=16.366003
            )
            session.add(user_golf)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=7,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_hotel = User(
                first_name='Hotel',
                last_name='Hotelson',
                email='hotel.hotelson@email.com',
                bio="Foodie on a perpetual quest for the perfect dish. Bon appétit!",
                date_of_birth=calculate_birthdate(20),
                job='Hotel Manager',
                search_radius=10,
                matching_algorithm=2,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_2],
                gender_preferences=[woman],
                gender_identity=woman,
                interests=[travel, books, technology, sports],
                password=hash_pwd("pass1"),
                latitude=48.214828,
                longitude=16.371755
            )
            session.add(user_hotel)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=8,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_journal = User(
                first_name='Journal',
                last_name='Journalson',
                email='journal.journalson@email.com',
                bio="Tech wizard by day, coding superhero by night.",
                date_of_birth=calculate_birthdate(19),
                job='Journalist',
                search_radius=35,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("french")],
                preferences=[preference_1, preference_2],
                gender_preferences=[woman, man],
                gender_identity=woman,
                interests=[writing, photography, sports],
                password=hash_pwd("pass1"),
                latitude=48.220692,
                longitude=16.376215
            )
            session.add(user_journal)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=9,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_kitchen = User(
                first_name='Kitchen',
                last_name='Kitchenson',
                email='kitchen.kitchenson@email.com',
                bio="Fashionista with an eye for style. Trends come and go, but style is eternal.",
                date_of_birth=calculate_birthdate(25),
                job='Chef',
                search_radius=18,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_1],
                gender_preferences=[man],
                gender_identity=man,
                interests=[food, gardening, travel],
                password=hash_pwd("pass1"),
                latitude=48.204692,
                longitude=16.361950
            )
            session.add(user_kitchen)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=10,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_lima = User(
                first_name='Lima',
                last_name='Limason',
                email='lima.limason@email.com',
                bio="Capturing moments through the lens. Photography is my visual diary.",
                date_of_birth=calculate_birthdate(26),
                job='Environmental Scientist',
                search_radius=25,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_2],
                gender_preferences=[woman],
                gender_identity=woman,
                interests=[nature, science, books],
                password=hash_pwd("pass1"),
                latitude=48.231217,
                longitude=16.355386
            )
            session.add(user_lima)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=11,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_mountain = User(
                first_name='Mountain',
                last_name='Mountainson',
                email='mountain.mountainson@email.com',
                bio="Gamer by heart, conqueror of virtual realms.",
                date_of_birth=calculate_birthdate(25),
                job='Mountain Guide',
                search_radius=30,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english")],
                preferences=[preference_1],
                gender_preferences=[man],
                gender_identity=man,
                interests=[nature, fitness, travel],
                password=hash_pwd("pass1"),
                latitude=48.205377,
                longitude=16.338982
            )
            session.add(user_mountain)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=12,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_novelist = User(
                first_name='Novelist',
                last_name='Novelistson',
                email='novelist.novelistson@email.com',
                bio="Nature lover, hiker, and eco-warrior. Let's protect our planet!",
                date_of_birth=calculate_birthdate(26),
                job='Novelist',
                search_radius=22,
                matching_algorithm=2,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("french")],
                preferences=[preference_1, preference_2],
                gender_preferences=[woman, man],
                gender_identity=divers,
                interests=[books, writing, movies],
                password=hash_pwd("pass1"),
                latitude=48.229243,
                longitude=16.328042
            )
            session.add(user_novelist)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=13,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_observatory = User(
                first_name='Observatory',
                last_name='Observatoryson',
                email='observatory.observatoryson@email.com',
                bio="Chasing sunsets and writing my story in the stars. Dreamer with a sprinkle of wanderlust.",
                date_of_birth=calculate_birthdate(22),
                job='Astronomer',
                search_radius=40,
                matching_algorithm=2,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_2],
                gender_preferences=[man],
                gender_identity=man,
                interests=[science, gaming, movies],
                password=hash_pwd("pass1"),
                latitude=48.215407,
                longitude=16.383019
            )
            session.add(user_observatory)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=14,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_painting = User(
                first_name='Painting',
                last_name='Paintingson',
                email='painting.paintingson@email.com',
                bio="Adventurous soul seeking the thrill of the unknown. Life is a journey, not a destination.",
                date_of_birth=calculate_birthdate(19),
                job='Visual Artist',
                search_radius=18,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("french")],
                preferences=[preference_1],
                gender_preferences=[woman],
                gender_identity=woman,
                interests=[art, photography, movies],
                password=hash_pwd("pass1"),
                latitude=48.198285,
                longitude=16.351907
            )
            session.add(user_painting)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=15,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_quiet = User(
                first_name='Quiet',
                last_name='Quietson',
                email='quiet.quietson@email.com',
                bio="Diving into history, one era at a time. A history buff with a curious mind.",
                date_of_birth=calculate_birthdate(21),
                job='Librarian',
                search_radius=15,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_2],
                gender_preferences=[woman],
                gender_identity=woman,
                interests=[books, philosophy, movies],
                password=hash_pwd("pass1"),
                latitude=48.221002,
                longitude=16.364694
            )
            session.add(user_quiet)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=16,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_robotics = User(
                first_name='Robotics',
                last_name='Roboticsson',
                email='robotics.roboticsson@email.com',
                bio="Fitness freak on a mission for a healthier lifestyle.",
                date_of_birth=calculate_birthdate(20),
                job='Robotics Engineer',
                search_radius=25,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_1],
                gender_preferences=[man],
                gender_identity=man,
                interests=[technology, coding, books],
                password=hash_pwd("pass1"),
                latitude=48.212813,
                longitude=16.339321
            )
            session.add(user_robotics)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=17,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_sailing = User(
                first_name='Sailing',
                last_name='Sailingson',
                email='sailing.sailingson@email.com',
                bio="Crafting dreams into reality. DIY enthusiast and creative spirit.",
                date_of_birth=calculate_birthdate(54),
                job='Marine Biologist',
                search_radius=30,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("french")],
                preferences=[preference_2],
                gender_preferences=[man],
                gender_identity=man,
                interests=[travel, nature, coding],
                password=hash_pwd("pass1"),
                latitude=48.225899,
                longitude=16.356740
            )
            session.add(user_sailing)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=18,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_theater = User(
                first_name='Theater',
                last_name='Theaterson',
                email='theater.theaterson@email.com',
                bio="Words are my playground. Writer weaving stories in the tapestry of life.",
                date_of_birth=calculate_birthdate(53),
                job='Theater Director',
                search_radius=20,
                matching_algorithm=2,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_1],
                gender_preferences=[woman],
                gender_identity=woman,
                interests=[movies, crafts, philosophy],
                password=hash_pwd("pass1"),
                latitude=48.207308,
                longitude=16.377155
            )
            session.add(user_theater)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=19,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_urban = User(
                first_name='Urban',
                last_name='Urbanoson',
                email='urban.urbanoson@email.com',
                bio="Green thumb and plant whisperer. Gardening is my therapy.",
                date_of_birth=calculate_birthdate(19),
                job='Urban Planner',
                search_radius=25,
                matching_algorithm=1,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("french")],
                preferences=[preference_2],
                gender_preferences=[man],
                gender_identity=man,
                interests=[technology, coding, history],
                password=hash_pwd("pass1"),
                latitude=48.219170,
                longitude=16.354686
            )
            session.add(user_urban)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=20,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_volunteer = User(
                first_name='Volunteer',
                last_name='Volunteerson',
                email='volunteer.volunteerson@email.com',
                bio="Philosopher in the making. Pondering the mysteries of existence.",
                date_of_birth=calculate_birthdate(23),
                job='Social Worker',
                search_radius=15,
                matching_algorithm=2,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english")],
                preferences=[preference_1],
                gender_preferences=[woman],
                gender_identity=woman,
                interests=[philosophy, fitness, coding],
                password=hash_pwd("pass1"),
                latitude=48.223641,
                longitude=16.341989
            )
            session.add(user_volunteer)
            with open("backend/datagenerator/data/female_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=21,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)

            user_wildlife = User(
                first_name='Wildlife',
                last_name='Wildlifeson',
                email='wildlife.wildlifeson@email.com',
                bio="Coding ninja with a keyboard as my sword. Debugging the matrix.",
                date_of_birth=calculate_birthdate(34),
                job='Wildlife Biologist',
                search_radius=30,
                matching_algorithm=3,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.today(),
                languages=[language_dict.get("english"), language_dict.get("german")],
                preferences=[preference_2],
                gender_preferences=[man],
                gender_identity=man,
                interests=[nature, photography, coding],
                password=hash_pwd("pass1"),
                latitude=48.231890,
                longitude=16.363775
            )
            session.add(user_wildlife)
            with open("backend/datagenerator/data/male_image.jpeg", "rb") as image_file:
                image = ProfilePicture(
                    user_id=22,
                    content=image_file.read(),
                    filename="test_image",
                    content_type="image/jpeg",
                )
                session.add(image)
            session.commit()

            # Rating
            alfa_bravo_rating = Rating(id=1, rating_user_id=user_alfa.id, rated_user_id=user_bravo.id, is_safe=True)

            session.add(user_alfa)
            session.add(user_bravo)
            session.commit()

            session.refresh(user_alfa)
            session.refresh(user_bravo)

            # Conversations
            for user in [user_bravo, user_charlie, user_delta, user_foxtrot, user_echo]:
                session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user.id, status=SwipeStatusType.match))
                session.add(Conversation(user1_id=user_alfa.id, user2_id=user.id))

            session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user_golf.id, status=SwipeStatusType.match))
            session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user_hotel.id, status=SwipeStatusType.match))
            session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user_kitchen.id, status=SwipeStatusType.match))
            session.add(SwipeStatus(user1_id=user_bravo.id, user2_id=user_charlie.id, status=SwipeStatusType.match))
            session.commit()

            # Rating
            alfa_bravo_rating = Rating(rating_user_id=user_alfa.id, rated_user_id=user_bravo.id, is_safe=True)
            session.add(alfa_bravo_rating)
            session.add(alfa_bravo_rating)
            session.commit()
            session.refresh(alfa_bravo_rating)

            # Expert System
            session.add(ExpertSystem(model=serialized_model, user_id=1))
            session.add(ExpertSystem(model=serialized_model, user_id=2))
            session.add(ExpertSystem(model=serialized_model, user_id=3))
            session.add(ExpertSystem(model=serialized_model, user_id=4))
            session.add(ExpertSystem(model=serialized_model, user_id=5))
            session.add(ExpertSystem(model=serialized_model, user_id=6))
            session.add(ExpertSystem(model=serialized_model, user_id=7))
            session.add(ExpertSystem(model=serialized_model, user_id=8))
            session.add(ExpertSystem(model=serialized_model, user_id=9))
            session.add(ExpertSystem(model=serialized_model, user_id=10))
            session.add(ExpertSystem(model=serialized_model, user_id=11))
            session.add(ExpertSystem(model=serialized_model, user_id=12))
            session.add(ExpertSystem(model=serialized_model, user_id=13))
            session.add(ExpertSystem(model=serialized_model, user_id=14))
            session.add(ExpertSystem(model=serialized_model, user_id=15))
            session.add(ExpertSystem(model=serialized_model, user_id=16))
            session.add(ExpertSystem(model=serialized_model, user_id=17))
            session.add(ExpertSystem(model=serialized_model, user_id=18))
            session.add(ExpertSystem(model=serialized_model, user_id=19))
            session.add(ExpertSystem(model=serialized_model, user_id=20))
            session.add(ExpertSystem(model=serialized_model, user_id=21))
            session.add(ExpertSystem(model=serialized_model, user_id=22))
            session.commit()

