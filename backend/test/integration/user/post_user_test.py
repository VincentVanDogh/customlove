import json
import io
from datetime import datetime
from operator import and_, or_
import re
import os
from dotenv import load_dotenv

from fastapi import UploadFile
from sqlmodel import select

from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.user import User
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.utils.passwords import verify_pwd


def test_post_create_user_positive_empty_options(client, session):
    __create_initial_data(client, session)

    email: str = "kilo@email.com"
    response = __post_request(client, '/users/', __define_header(), __new_user_data(email=email))

    assert response.status_code == 200

    user: User = (session.exec(select(User).where(User.email == email))).first()
    gender_preferences = (session.exec(select(GenderIdentity).where(or_(GenderIdentity.id == 1, GenderIdentity.id == 2)))).all()
    interests = (session.exec(select(Interest).where(or_(Interest.id == 1, Interest.id == 2)))).all() + (session.exec(select(Interest).where(Interest.id == 3))).all()

    assert (
            user.first_name == 'Kilo' and
            user.last_name == 'Kiloson' and
            user.email == email and
            verify_pwd("pass1", user.password) and
            user.gender_identity.id == 1 and
            user.date_of_birth == datetime(1990, 11, 17, 20, 6, 55) and
            user.search_radius == 50 and
            user.matching_algorithm == 1 and
            user.swipes_left == int(os.getenv('SWIPE_LIMIT')) and
            user.gender_preferences == gender_preferences and
            user.interests == interests and
            user.latitude == 20 and
            user.longitude == 20 and
            user.bio is '' and
            user.job is '' and
            user.languages == []
    )


def test_post_create_user_positive_filled_options(client, session):
    __create_initial_data(client, session)

    email: str = "kilo@email.com"
    response = __post_request(
        client,
        '/users/',
        __define_header(),
        __new_user_data(bio="Test person", job="Validates", language_ids="[1, 2]")
    )

    assert response.status_code == 200

    user: User = (session.exec(select(User).where(User.email == email))).first()
    gender_preferences = (session.exec(select(GenderIdentity).where(or_(GenderIdentity.id == 1, GenderIdentity.id == 2)))).all()
    interests = (session.exec(select(Interest).where(or_(Interest.id == 1, Interest.id == 2)))).all() + (session.exec(select(Interest).where(Interest.id == 3))).all()
    languages = (session.exec(select(Language).where(or_(Language.id == 1, Language.id == 2)))).all()

    assert (
            user.first_name == 'Kilo' and
            user.last_name == 'Kiloson' and
            user.email == email and
            verify_pwd("pass1", user.password) and
            user.gender_identity.id == 1 and
            user.date_of_birth == datetime(1990, 11, 17, 20, 6, 55) and
            user.search_radius == 50 and
            user.matching_algorithm == 1 and
            user.swipes_left == int(os.getenv('SWIPE_LIMIT')) and
            user.gender_preferences == gender_preferences and
            user.interests == interests and
            user.latitude == 20 and
            user.longitude == 20 and
            user.bio == 'Test person' and
            user.job == 'Validates' and
            user.languages == languages
    )


def test_post_create_user_negative_duplicate_email(client, session):
    __create_initial_data(client, session)

    email: str = "kilo@email.com"
    response = __post_request(client, '/users/', __define_header(), __new_user_data(email=email))

    assert response.status_code == 200

    response = __post_request(client, '/users/', __define_header(), __new_user_data(email=email))

    assert response.status_code == 422
    assert __extract_response_content(response.content.decode('utf-8')) == "User with provided email already exists"
    user = session.exec(select(User).where(User.email == "kilo@email.com")).all()
    assert len(user) == 1


def test_post_create_user_negative_names(client, session):
    __create_initial_data(client, session)

    email: str = "kilo@email.com"
    response = __post_request(
        client,
        '/users/',
        __define_header(),
        __new_user_data(first_name="        ", last_name="      ")
    )

    assert response.status_code == 422
    assert __extract_response_content(response.content.decode('utf-8')) == 'First name cannot be empty, Last name cannot be empty'
    user = session.exec(select(User).where(User.email == "kilo@email.com")).all()
    assert len(user) == 0

    response = __post_request(
        client,
        '/users/',
        __define_header(),
        __new_user_data(first_name="a" * 300, last_name="      ")
    )
    assert response.status_code == 422
    assert __extract_response_content(response.content.decode('utf-8')) == 'Last name cannot be empty, First name cannot be longer than 256 characters'
    user = session.exec(select(User).where(User.email == "kilo@email.com")).all()
    assert len(user) == 0


def test_post_create_user_negative_radius(client, session):
    __create_initial_data(client, session)

    email: str = "kilo@email.com"
    response = __post_request(
        client,
        '/users/',
        __define_header(),
        __new_user_data(search_radius=3)
    )

    assert response.status_code == 422
    assert __extract_response_content(response.content.decode('utf-8')) == 'Search radius must be between 5 km and 100 km'
    user = session.exec(select(User).where(User.email == "kilo@email.com")).all()
    assert len(user) == 0


def test_post_create_user_negative_interests(client, session):
    __create_initial_data(client, session)

    response = __post_request(
        client,
        '/users/',
        __define_header(),
        __new_user_data(interest_ids='[1, 2]')
    )

    assert response.status_code == 422
    assert __extract_response_content(response.content.decode('utf-8')) == 'User requires 3 - 5 interests'
    user = session.exec(select(User).where(User.email == "kilo@email.com")).all()
    assert len(user) == 0


def test_post_create_user_negative_gender_preference(client, session):
    pass


def test_post_create_user_negative_dob(client, session):
    pass


def __create_initial_data(client, session) -> None:
    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")
    divers = GenderIdentity(name="divers")

    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")
    books = Interest(name="books", icon="icon4")

    english = Language(name="english")
    german = Language(name="german")
    french = Language(name="french")

    session.add(man)
    session.add(woman)
    session.add(divers)

    session.add(sports)
    session.add(movies)
    session.add(travel)
    session.add(books)

    session.add(english)
    session.add(german)
    session.add(french)

    session.commit()


def __new_user_data(
        first_name: str = "Kilo",
        last_name: str = "Kiloson",
        email: str = "kilo@email.com",
        password: str = "pass1",
        gender_identity_id: int = 1,
        date_of_birth: str = "1990-11-17T20:06:55.441841",
        search_radius: int = 50,
        matching_algorithm: int = 1,
        gender_preference_ids: str = "[1, 2]",
        interest_ids: str = "[1, 2, 3]",
        latitude: int = 20,
        longitude: int = 20,
        bio: str = None,
        job: str = None,
        language_ids: str = None
):
    return {
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "password": password,
        "gender_identity_id": gender_identity_id,
        "date_of_birth": date_of_birth,
        "search_radius": search_radius,
        "matching_algorithm": matching_algorithm,
        "gender_preference_ids": gender_preference_ids,
        "interest_ids": interest_ids,
        "latitude": latitude,
        "longitude": longitude,
        "bio": bio,
        "job": job,
        "language_ids": language_ids
    }


def __post_request(client, route: str, headers: {str: str}, data: {str: str | int | None}):
    return client.post(
        route,
        headers=headers,
        data=data
    )


def __define_header(content_type: str = 'application/x-www-form-urlencoded', accept: str = 'application/json'):
    return {
        "Content-Type": content_type,
        'accept': accept
    }


def __extract_response_content(response: str) -> str:
    input_re = re.match(r'{"detail":"(.*?)"}', response)
    return input_re.group(1)
