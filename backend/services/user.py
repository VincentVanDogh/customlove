import datetime
import random
from typing import List, Annotated, Optional
import re
from dotenv import load_dotenv
import os
from fastapi import Depends, UploadFile, Form
from fastapi.security import OAuth2PasswordRequestForm
from fastapi_pagination.ext.sqlmodel import paginate
from geoalchemy2 import functions, Geography
from pydantic import BaseModel, Field
from shapely import geometry, wkt
from sqlalchemy import or_, and_, exists, text
from sqlmodel import Session, select
from starlette.requests import Request
from starlette.websockets import WebSocket, WebSocketDisconnect
from typing import List, Annotated

from backend.algo.exsys import ExSys
from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.mapper.user_mapper import map_user_to_user_response_with_interests, map_user_to_user_response
from backend.models.gender_identity import GenderIdentity
from backend.models.image import ProfilePicture
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.connectors.user_has_gender_preference import UserHasGenderPreference
from backend.models.message import Message, message_factory
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.repository.repository import create_session
from backend.requests.user_request import UserUpdateProfile
from backend.responses.notification import Notification, NotificationType
from backend.responses.user_response import UserResponseWithInterestsAndDistance, UserResponse, UserDetailedResponse, \
    ProfileResponse
from backend.services.expert_system import get_expert_system_by_user_id
from backend.services.expert_system import update_expert_system
from backend.services.message import _save_message
from backend.services.validation.user_validation import validate_new_user
from backend.utils import passwords
from backend.utils.connection_manager import connection_manager
from backend.utils.logger import Logger
from backend.utils.pagination import PaginationParams
from backend.utils.passwords import hash_pwd
from backend.utils.token import create_access_token, get_current_user

load_dotenv()

class UserUpdate(BaseModel):
    latitude: float = Field(None, title="Latitude")
    longitude: float = Field(None, title="Longitude")
    swiped: bool = Field(None, title="Swiped")
    algo_id: int = Field(None, title="AlgoId")


def get_user(user_id: int, user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(create_session)]) -> User:
    """
    Return a specific user
    :param db: injected database
    :param user_id: user's id
    :return: a user object
    """
    statement = select(User).where(User.id == user_id)
    user: list[User] = db.exec(statement).all()
    if len(user) == 0:
        raise NotFoundException(f"Could not find users with id = {user_id}")
    elif len(user) > 1:
        raise BadRequestException(f"More than one user for id = {user_id} was found")

    return user[0]


def get_user_by_email(user_email: str, db: Annotated[Session, Depends(create_session)]) -> User:
    """
    Return a specific user based on their username (email)
    :param user_email: user email
    :param db: injected database
    :return: a user object
    """
    user: User = db.exec(select(User).where(User.email == user_email)).first()
    if user is None:
        raise NotFoundException("Username does not exist")

    return user


def get_users(user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(create_session)],
              request: Request) -> List[User]:
    """
    Retrieves all users, with whom the querying user has a match
    :return: a list of users
    """
    return paginate(db, select(User).join(SwipeStatus, onclause=and_(
        or_(SwipeStatus.user1_id == User.id, SwipeStatus.user2_id == User.id),
        SwipeStatus.status == SwipeStatusType.match))
                    .where(and_(User.id != user.id,
                                or_(SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user.id))),
                    PaginationParams(size=request.query_params.get("size"),
                                     page=request.query_params.get("page")))


def registration(
        db: Annotated[Session, Depends(create_session)],
        first_name: Annotated[str, Form()],
        last_name: Annotated[str, Form()],
        email: Annotated[str, Form()],
        password: Annotated[str, Form()],
        date_of_birth: Annotated[str, Form()],
        search_radius: Annotated[str, Form()],
        gender_identity_id: Annotated[str, Form()],
        gender_preference_ids: Annotated[str, Form()],
        longitude: Annotated[str, Form()],
        latitude: Annotated[str, Form()],
        interest_ids: Annotated[str, Form()],
        matching_algorithm: Annotated[str, Form()],
        profile_picture: Optional[UploadFile] = Form(default=None),
        bio: Optional[Annotated[str, Form()]] = Form(default=None),
        job: Optional[Annotated[str, Form()]] = Form(default=None),
        language_ids: Optional[Annotated[str, Form()]] = Form(default=None),
) -> {}:
    """
    Create a user
    :param db: injected database
    :param first_name: first name of the user
    :param last_name: last name of the user
    :param email: email of the user
    :param password: password of a user
    :param date_of_birth: birthdate of a user
    :param search_radius: search radius of potential matched
    :param gender_identity_id: gender identity id of the user
    :param gender_preference_ids: list of gender preference id's of the user
    :param longitude: longitude of the user
    :param latitude: latitude of the user
    :param interest_ids: list of interest id's of the user
    :param matching_algorithm: matching algorithm of the user
    :param profile_picture: profile picture of the user
    :param bio: optional bio of the user
    :param job: optional job of the user
    :param language_ids: optional list of language id's of the user
    :return: a user object
    """
    first_name = first_name.strip()
    last_name = last_name.strip()
    email = email.strip()
    search_radius = int(search_radius)

    # Retrieving properties from the db based on the id's
    user_gender_preferences: [GenderIdentity] = []
    user_interests: [Interest] = []
    user_languages: [Language] = []
    for interest_id in __array_string_to_array(interest_ids):
        user_interests.append(db.exec(select(Interest).where(Interest.id == interest_id)).first())

    if language_ids is not None:
        for language_id in __array_string_to_array(language_ids):
            user_languages.append(db.exec(select(Language).where(Language.id == language_id)).first())

    for gender_id in __array_string_to_array(gender_preference_ids):
        user_gender_preferences.append(db.exec(select(GenderIdentity).where(GenderIdentity.id == gender_id)).first())

    # Validating if provided values are valid
    date_of_birth_datetime: datetime = __datetime_string_to_datetime(date_of_birth)

    # Does a user with provided email already exist? If so, throw an exception
    users = db.exec(select(User).where(User.email == email)).all()
    if len(users) > 0:
        raise ValidationException(message="User with provided email already exists")


    # Do other properties violate against certain constraints? If so, throw an exception
    user_validation: [str] = validate_new_user(
        first_name, last_name, email, bio, job, date_of_birth_datetime, user_interests, user_gender_preferences, search_radius
    )
    if len(user_validation) > 0:
        raise ValidationException(message=', '.join(user_validation))

    gender_identity = db.exec(select(GenderIdentity).where(GenderIdentity.id == int(gender_identity_id))).first()

    # Map user
    register_user: User = User(
                first_name=first_name,
                last_name=last_name,
                email=email,
                bio=bio if bio is not None else "",
                date_of_birth=__datetime_string_to_datetime(date_of_birth),
                job=job if job is not None else "",
                search_radius=search_radius,
                swipes_left=os.getenv('SWIPE_LIMIT'),
                swipe_limit_reset_date=datetime.datetime.now() + datetime.timedelta(days=1),
                languages=user_languages,
                preferences=[],
                gender_preferences=user_gender_preferences,
                gender_identity=gender_identity,
                interests=user_interests,
                password=hash_pwd(password),
                latitude=latitude,
                longitude=longitude,
                matching_algorithm=matching_algorithm
            )

    # Store user in the db
    db.add(register_user)
    db.commit()
    db.refresh(register_user)

    if (profile_picture != None):
        user_id: int = db.exec(select(User).where(User.email == email)).first().id

        # Map image
        image = ProfilePicture(
            user_id=user_id,
            content=profile_picture.file.read(),
            filename=profile_picture.filename,
            content_type=profile_picture.content_type
        )

        # Store image in the db
        db.add(image)
        db.commit()
        db.refresh(image)

    access_token = create_access_token(data={"sub": register_user.email})
    return {"access_token": access_token, "token_type": "bearer", "user": register_user}


def patch_user(updated_user: UserUpdate, user: Annotated[User, Depends(get_current_user)],
               db: Annotated[Session, Depends(create_session)]) -> UserResponse:
    """
        Update a user
        :param db: injected database
        :param user: a user object
        :return: a user object
    """
    # TODO: check if the other fields should be updated
    for key in updated_user.__dict__.items():
        if "swiped" in key and updated_user.swiped is not None:
            if datetime.datetime.now() < user.swipe_limit_reset_date:
                if user.swipes_left != 0:
                    user.swipes_left = user.swipes_left - 1
            else:
                update_expert_system(user, db)
                user.swipe_limit_reset_date = datetime.datetime.now() + datetime.timedelta(hours=24)
                user.swipes_left = os.getenv('SWIPE_LIMIT')
        elif "algo_id" in key and updated_user.algo_id is not None:
            user.matching_algorithm = updated_user.algo_id
        elif "latitude" in key:
            if updated_user.latitude is not None and updated_user.longitude is not None:
                user.latitude = updated_user.latitude
                user.longitude = updated_user.longitude

                point = geometry.Point(user.longitude, user.latitude)
                wkt_point = wkt.dumps(point)

                user.location = wkt_point

    db.commit()
    db.refresh(user)
    return map_user_to_user_response(user)


def patch_user_profile(
        updated_user: UserUpdateProfile,
        user: Annotated[User, Depends(get_current_user)],
        db: Annotated[Session, Depends(create_session)]
) -> UserDetailedResponse:
    user_gender_preferences: [GenderIdentity] = []
    user_interests: [Interest] = []
    user_languages: [Language] = []

    if updated_user.interest_ids is not None:
        for interest_id in updated_user.interest_ids:
            user_interests.append(db.exec(select(Interest).where(Interest.id == interest_id)).first())
        user.interests = user_interests

    if updated_user.language_ids is not None:
        for language_id in updated_user.language_ids:
            user_languages.append(db.exec(select(Language).where(Language.id == language_id)).first())
        user.languages = user_languages

    if updated_user.gender_preference_ids:
        for gender_id in updated_user.gender_preference_ids:
            user_gender_preferences.append(db.exec(select(GenderIdentity).where(GenderIdentity.id == gender_id)).first())
        user.gender_preferences = user_gender_preferences

    if updated_user.job is not None:
        user.job = updated_user.job
    if updated_user.bio is not None:
        user.bio = updated_user.bio
    if updated_user.search_radius is not None:
        user.search_radius = updated_user.search_radius

    db.add(user)
    db.commit()
    db.refresh(user)

    fetched_image = db.exec(select(ProfilePicture).where(ProfilePicture.user_id == user.id)).first()
    if fetched_image is not None:
        return __user_to_user_profile(user, fetched_image.id)
    else:
        return __user_to_user_profile(user, None)


def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()], db: Annotated[Session, Depends(create_session)]):
    user = db.exec(select(User).where(User.email == form_data.username)).first()
    if user is None:
        raise NotFoundException("Username does not exist")

    if not passwords.verify_pwd(form_data.password, user.password):
        raise CredentialsException("Wrong Password")

    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer", "user": user}


def get_swipeable_user(user, db):
    subquery = (
        select([User.location])
        .where(User.id == user.id)
    ).alias("user_location")

    user_gender_pref_subquery = (
        select([UserHasGenderPreference.gender_identity_id])
        .where(UserHasGenderPreference.user_id == user.id)
    ).alias("user_gender_preference")

    query = (
        select([User])
        .where(
            functions.ST_DWithin(
                User.location.cast(Geography),
                subquery.c.location.cast(Geography),
                user.search_radius * 1000
            )
        )
        .where(User.id != user.id)
        .where(
            User.gender_identity_id == user_gender_pref_subquery.c.gender_identity_id
        )
        .where(
            ~exists(
                select([1])
                .where(
                    or_(
                        and_(SwipeStatus.user2_id == User.id,
                             SwipeStatus.user1_id == user.id,
                             SwipeStatus.status.in_(['view', 'like', 'match'])
                             ),
                        and_(SwipeStatus.user1_id == User.id,
                             SwipeStatus.user2_id == user.id,
                             SwipeStatus.status == 'match'
                             )
                    )
                )
            )
        )
    )
    return db.exec(query).fetchall()


def get_algo_user(algoId: int, user: Annotated[User, Depends(get_current_user)],
                  db: Annotated[Session, Depends(create_session)],
                  request: Request) -> UserResponseWithInterestsAndDistance | None:
    swipeable_user = get_swipeable_user(user, db)

    if len(swipeable_user) == 0:
        return None

    match algoId:
        case 1:
            swipeable_user_choice = random.choice(swipeable_user)
            return map_user_to_user_response_with_interests(
                swipeable_user_choice,
                get_distance(user, swipeable_user_choice, db)
            )
        case 2:
            return get_user_with_common_interests(user, swipeable_user, db)
        case 3:
            # Get expertsytem of current user
            expert_system = get_expert_system_by_user_id(user.id, db)

            # Get the model of the current user
            current_model = expert_system.model

            # Initialize an Exsys for the current user and set the serialized model, retrieved from the database
            exsys = ExSys(None)
            exsys.deserialize_and_set_model(current_model)

            # Compute the user_id with the highest prediction from the all users in the given radius
            # TODO Use the prediction for something like: "Particularly Compatible! (#65)"
            user_id_with_highest_prediction, prediction = exsys.predict(swipeable_user)

            swipeable_user_choice = [user for user in swipeable_user if user.id == user_id_with_highest_prediction][0]
            # return the user with the user.id = user_id_with_highest_prediction
            return map_user_to_user_response_with_interests(swipeable_user_choice,
                                                            get_distance(user, swipeable_user_choice, db))
        case _:
            return None


def get_user_with_common_interests(user, swipeable_user_list, db):
    user_interests = set(user.interests)

    most_common_user = max(swipeable_user_list, key=lambda su: len(set(user_interests).intersection(set(su.interests))),
                           default=None)
    return map_user_to_user_response_with_interests(most_common_user, get_distance(user, most_common_user,
                                                                                   db)) if most_common_user else None


async def websocket_connect(websocket: WebSocket, user_token: str, db: Annotated[Session, Depends(create_session)]):
    user: User = get_current_user(user_token, db)
    Logger.debug(f"[websocket_connect]: connected on a websocket: {websocket} with the user: {user.id}")

    await connection_manager.connect(websocket, user.id)
    try:
        while True:
            notification: Notification = Notification(await websocket.receive_json())
            # data: Message = message_factory(await websocket.receive_json())
            Logger.debug(
                f"[websocket_connect]: received a notification from: user #{user.id}, contents: {notification}")

            if notification.type == NotificationType.message:
                message: Message = message_factory(notification.content)
                message = _save_message(message, db)
                notification.content = message

                # send the message to the receiver
                await connection_manager.send_notification(message.receiver_id, notification)

                # send the message to all devices of the sender
                await connection_manager.send_notification(message.sender_id, notification)

    except WebSocketDisconnect:
        connection_manager.disconnect(websocket, user.id)


def get_user_profile(
        user_id: int,
        user: Annotated[User, Depends(get_current_user)],
        db: Annotated[Session, Depends(create_session)]
) -> ProfileResponse:
    """
    Return a specific user
    :param db: injected database
    :param user_id: user's id
    :return: a user object
    """
    interests: [Interest] = db.exec(select(Interest)).all()
    genders: [GenderIdentity] = db.exec(select(GenderIdentity)).all()
    languages: [Language] = db.exec(select(Language)).all()
    fetched_image = db.exec(select(ProfilePicture).where(ProfilePicture.user_id == user_id)).first()

    if fetched_image is not None:

        profile: UserDetailedResponse = __user_to_user_profile(user, fetched_image.id)
        return ProfileResponse(
            user=profile,
            interests=interests,
            genders=genders,
            languages=languages
        )
    else:
        profile: UserDetailedResponse = __user_to_user_profile(user, None)
        return ProfileResponse(
            user=profile,
            interests=interests,
            genders=genders,
            languages=languages
        )


def __user_to_user_profile(user: User, profile_picture_id: int | None) -> UserDetailedResponse:
    """
    Maps the object of class User to an object which also displays 1:n relationships.
    :param user: user of type User
    :return: a newly mapped users which also contains 1:n relationships
    """
    return UserDetailedResponse(
        id=user.id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        password=user.password,
        bio=user.bio,
        date_of_birth=user.date_of_birth,
        job=user.job,
        search_radius=user.search_radius,
        gender_identity=user.gender_identity,
        gender_preferences=user.gender_preferences,
        swipes_left=user.swipes_left,
        swipe_limit_reset_date=user.swipe_limit_reset_date,
        latitude=user.latitude,
        longitude=user.longitude,
        interests=user.interests,
        languages=user.languages,
        matching_algorithm=user.matching_algorithm,
        profile_picture_id=profile_picture_id
    )


def get_distance(current_user, swipeable_user, db):
    query = text(
        f"""
        SELECT
    ST_DistanceSphere(
        u1.location::geometry,
        u2.location::geometry
    ) AS distance
    FROM
        "user" u1
    JOIN
        "user" u2 ON u1.id = {current_user.id} AND u2.id = {swipeable_user.id};
        """
    )

    result = db.execute(query).first()[0]

    # Distance in km
    distance = round(result / 1000)

    # For safety reasons the lowest km which is shown is 5
    return distance if distance > 5 else 5


def __datetime_string_to_datetime(input_string: str) -> datetime:
    """
    Converts a string datetime value to datetime.
    :param input_string: datetime of type string
    :return: datetime of type datetime
    """
    format_string = '%Y-%m-%dT%H:%M:%S'
    input_re = re.match(r'^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})', input_string)
    input_string = input_re.group(1)

    # Step 1: Parse the string without milliseconds
    parsed_datetime: datetime = datetime.datetime.strptime(input_string, format_string)

    return parsed_datetime


def __array_string_to_array(input_string: str) -> [int]:
    """
    Converts a string array value to an integer-array.
    :param input_string: array of type string
    :return: integer-array of type array
    """
    if input_string.strip() == '[]':
        return []
    res = input_string.strip('][').split(', ')
    return [int(x) for x in res]
