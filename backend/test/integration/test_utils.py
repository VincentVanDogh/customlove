from datetime import datetime

from sqlmodel import Session
from starlette.testclient import TestClient
from typing import List, Any

from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.preference import Preference
from backend.models.user import User
from backend.test.integration.utils.gender_factory import GenderFactory
from backend.utils.passwords import hash_pwd

RAW_PASSWORD = "pass1"
gender_factory = GenderFactory()


def interest(name):
    return Interest(name=name, icon="")


def language(name):
    return Language(name=name)


def gender_identity(name):
    return GenderIdentity(name=name)


def random_preferences(num):
    preferences = []
    for i in range(num):
        preferences.append(Preference(property_1=f"property{i}", property_2=f"property{i + 1}", decision=f"decision{i}",
                                      date=datetime.now()))

    return preferences


def user_alfa():
    return User(
        id=1,
        first_name='Alfa',
        last_name='Alfonson',
        email='alfa.alfonson@email.com',
        tel='+43 231 472 941',
        bio='Test subject',
        date_of_birth=datetime.today(),
        job='Software Engineer',
        search_radius=200,
        matching_algorithm=1,
        swipes_left=10,
        swipe_limit_reset_date=datetime.today(),
        languages=[language("english")],
        gender_preferences=[gender_identity("woman")],
        preferences=random_preferences(5),
        gender_identity=gender_identity("woman"),
        interests=[interest("sports"), interest("movies")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_beta():
    return User(
        id=2,
        first_name='Bravo',
        last_name='Bravonson',
        email='bravo.bravonson@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        matching_algorithm=1,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("french"), language("german")],
        gender_preferences=[gender_identity("man"), gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_identity("woman"),
        interests=[interest("travel"), interest("books"), interest("science")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_gamma():
    return User(
        id=3,
        first_name='Gamma',
        last_name='Gammonson',
        email='gamma.gammonson@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        matching_algorithm=1,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("french"), language("german")],
        gender_preferences=[gender_identity("man"), gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_identity("woman"),
        interests=[interest("travel"), interest("books"), interest("science")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_theater():
    return User(
        id=4,
        first_name='Theater',
        last_name='Theaterson',
        email='theater.theaterson@email.com',
        tel='+92 231 023 953',
        bio="Words are my playground. Writer weaving stories in the tapestry of life.",
        date_of_birth=datetime.today(),
        job='Theater Director',
        search_radius=20,
        matching_algorithm=2,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("german")],
        gender_preferences=[gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_identity("woman"),
        interests=[interest("movies"), interest("crafts"), interest("philosophy")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_alex():
    return User(
        id=5,
        first_name='Alex',
        last_name='Anderson',
        email='alex.anderson@email.com',
        tel='+43 231 472 941',
        bio='Test subject',
        date_of_birth=datetime.today(),
        job='Software Engineer',
        search_radius=200,
        matching_algorithm=1,
        swipes_left=10,
        swipe_limit_reset_date=datetime.today(),
        languages=[language("english")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(5),
        gender_identity=gender_factory.get_or_create_gender_identity("man"),
        interests=[interest("sports"), interest("movies")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_bob():
    return User(
        id=6,
        first_name='Bob',
        last_name='Baker',
        email='bob.baker@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        matching_algorithm=1,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("french"), language("german")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("man"),
                            gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_factory.get_or_create_gender_identity("woman"),
        interests=[interest("travel"), interest("books"), interest("science")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_charlie():
    return User(
        id=7,
        first_name='Charlie',
        last_name='Carter',
        email='charlie.carter@email.com',
        tel='+92 231 023 953',
        bio='Test subject 3',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        matching_algorithm=1,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("french"), language("german")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("man"),
                            gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_factory.get_or_create_gender_identity("woman"),
        interests=[interest("travel"), interest("books"), interest("science")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_diana():
    return User(
        id=8,
        first_name='Diana',
        last_name='Dawson',
        email='diana.dawson@email.com',
        tel='+92 231 023 953',
        bio="Words are my playground. Writer weaving stories in the tapestry of life.",
        date_of_birth=datetime.today(),
        job='Theater Director',
        search_radius=20,
        matching_algorithm=2,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("german")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_factory.get_or_create_gender_identity("woman"),
        interests=[interest("movies"), interest("crafts"), interest("philosophy")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_emma():
    return User(
        id=9,
        first_name='Emma',
        last_name='Evans',
        email='emma.evans@email.com',
        tel='+43 231 472 941',
        bio='Test subject 1',
        date_of_birth=datetime.today(),
        job='Software Engineer',
        search_radius=200,
        matching_algorithm=1,
        swipes_left=10,
        swipe_limit_reset_date=datetime.today(),
        languages=[language("english")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(5),
        gender_identity=gender_factory.get_or_create_gender_identity("woman"),
        interests=[interest("sports"), interest("movies")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_frank():
    return User(
        id=10,
        first_name='Frank',
        last_name='Fisher',
        email='frank.fisher@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        matching_algorithm=1,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("french"), language("german")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("man"),
                            gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_factory.get_or_create_gender_identity("woman"),
        interests=[interest("travel"), interest("books"), interest("science")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_george():
    return User(
        id=11,
        first_name='George',
        last_name='Gray',
        email='george.gray@email.com',
        tel='+92 231 023 953',
        bio='Test subject 3',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        matching_algorithm=1,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("french"), language("german")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("man"),
                            gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_factory.get_or_create_gender_identity("woman"),
        interests=[interest("travel"), interest("books"), interest("science")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def user_hannah():
    return User(
        id=12,
        first_name='Hannah',
        last_name='Hunt',
        email='hannah.hunt@email.com',
        tel='+92 231 023 953',
        bio="Words are my playground. Writer weaving stories in the tapestry of life.",
        date_of_birth=datetime.today(),
        job='Theater Director',
        search_radius=20,
        matching_algorithm=2,
        swipe_limit_reset_date=datetime.today(),
        swipes_left=5,
        languages=[language("english"), language("german")],
        gender_preferences=[gender_factory.get_or_create_gender_identity("woman")],
        preferences=random_preferences(2),
        gender_identity=gender_factory.get_or_create_gender_identity("woman"),
        interests=[interest("movies"), interest("crafts"), interest("philosophy")],
        password=hash_pwd(RAW_PASSWORD),
        latitude=48.227982,
        longitude=16.372316
    )


def load_entities(entities: List[Any], session: Session):
    for entity in entities:
        session.add(entity)

    session.commit()

    for entity in entities:
        session.refresh(entity)


def login(email: str, pwd: str, client):
    headers = {"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"}
    response = client.post("/users/login", headers=headers, data={"username": f"{email}", "password": f"{pwd}"})
    return response.json()['access_token']


def authorized_request(token, client: TestClient, method, url, **kwargs):
    headers = {"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded",
               "Authorization": f"Bearer {token}"}

    if 'files' in kwargs:
        headers = {"Authorization": f"Bearer {token}"}

    return method(client)(url, headers=headers, **kwargs)


def create_expert_system(userId: int, session: Session):
    from backend.algo.exsys import ExSys
    expert_system = ExSys(None)

    # Create training data
    X_train = []

    # Target Data
    y_train = []

    # Add training user data
    from backend.datagenerator.data.exsys_training_data import exsys_trainings_data
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

    from backend.models.expert_system import ExpertSystem
    session.add(ExpertSystem(model=serialized_model, user_id=userId))


def clear_gender_cache():
    gender_factory.clean_cache()
