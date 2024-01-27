from operator import and_, or_
from typing import Annotated, List
from fastapi import Depends
from sqlmodel import Session, select, update
from backend.algo.exsys import ExSys
from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.models.expert_system import ExpertSystem
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.repository.repository import create_session
from backend.requests.train_data_decisions import DecisionsRequest
from backend.utils.token import get_current_user
from backend.services.swipe_status import set_swipe_status_trained_for_model_true
from backend.datagenerator.data.exsys_training_data import exsys_trainings_data



def get_expert_system_by_user_id(user_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return the expert system from the given user
    :param user_id: id of user of the expert system
    :param db: injected database
    :return: an ExpertSystem object
    """
    statement = select(ExpertSystem).where(ExpertSystem.user_id == user_id)
    expert_system: list[ExpertSystem] = db.exec(statement).all()
    if len(expert_system) == 0:
        raise NotFoundException(f"Could not find expert system for  user with id = {user_id}")
    elif len(expert_system) > 1:
        raise BadRequestException(f"More than one expert systems of user with id = {user_id}")
    return expert_system[0]



def train_model(decisions_request: DecisionsRequest):
    """
    Train the model using ExSys class
    :param decisions_request: decisions from the user on training data
    :return: trained ExSys object
    """
    expert_system = ExSys(None)

    # Create training data
    X_train = []

    # Add training user data
    for dummyuser in exsys_trainings_data:
        actual_user = exsys_trainings_data.get(dummyuser)
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

    y_train = decisions_request.decisions

    expert_system.train_model_with_fixed_training_data(X_train, y_train)

    return expert_system

def post_expert_system(user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(create_session)],
                       decisions_request: DecisionsRequest):
    """
    Create an expert system, this function should be only used in the sign-up process
    :param decisions_request: decisions from the user on training data
    :param user: current user
    :param db: injected database
    :return: an ExpertSystem object (with the id)
    """

    if not set(decisions_request.decisions) == {0, 1}:
        return BadRequestException("Decisions have to contain likes and dislikes!")

    if not len(decisions_request.decisions) == 14:
        return BadRequestException("It has to be exactly 14 decisions!")

    trained_exsys = train_model(decisions_request)

    serialized_model = trained_exsys.serialize_model()

    expert_system = ExpertSystem(model=serialized_model, user_id=user.id)

    db.add(expert_system)
    db.commit()
    db.refresh(expert_system)
    return f"Added Expert System for User with Id {user.id}"


def update_expert_system(user: Annotated[User, Depends(get_current_user)],
                         db: Annotated[Session, Depends(create_session)]):
    """
    Update the given expert system, the user is the same as in the old one
    :param user_id: the user which updating expert system refers to
    :param user: current user
    :param db: injected database
    :return: the new ExpertSystem object (with the id)
    """
    expert_system = None
    try:
        # Get expertsytem of current user
        expert_system = get_expert_system_by_user_id(user.id, db)
    except Exception as e:
        if e is NotFoundException:
            raise NotFoundException(f"Could not find expert system of user with id = {user.id} "
                                    f"when trying to update the expert system")
        elif e is BadRequestException:
            raise BadRequestException(f"More than one expert systems of user with id = {user.id} "
                                      f"where found when trying to update the expert system")

    if expert_system is not None:
        # Get the model of the current user
        current_model = expert_system.model

        # Initialize a Exsys for the current user and set the serialized model, retrieved from the database
        exsys = ExSys(None)
        exsys.deserialize_and_set_model(current_model)

        # Get the recent swipes to update the model
        liked_users = get_liked_users_not_trained_on(db, user.id)
        viewed_users = get_viewed_users_not_trained_on(db, user.id)


        # Logic regression Model only works with more than one class, so liked and viewed user have to exist
        if len(liked_users) != 0 and len(viewed_users) != 0:
            # Update Model of expert system with these users
            exsys.update_model(liked_users, viewed_users)

            # Set trained for model flags true
            set_swipe_status_trained_for_model_true(db, user)
        else:
            return "Expert System hat not been updated due missing at least one class (View/Like)"

        # Serialize the updated model and use for the expert system update
        expert_system.model = exsys.serialize_model()
        db.add(expert_system)
        db.commit()
        db.refresh(expert_system)
        return "Updated Expert System"
    else:
        raise BadRequestException(f"A error occurred when updating the model of the expert system of the user with id ="
                                  f"{user.id}")



def get_liked_users_not_trained_on(db, userid) -> List[User]:
    """
    Retrieves all users, whom the querying user has liked and the expert system isn't trained on yet
    :param db: db instance
    :param userid: id of current user
    :return: a list of users
    """
    statement = (select(User).join(SwipeStatus, onclause=and_(or_(SwipeStatus.user1_id == User.id,
                SwipeStatus.user2_id == User.id), SwipeStatus.status == SwipeStatusType.like))
                 .where(and_(SwipeStatus.used_for_model == False,
                             and_(User.id != userid, SwipeStatus.user1_id == userid))))

    user_list = db.exec(statement).all()

    return user_list



def get_viewed_users_not_trained_on(db, userid) -> List[User]:
    """
    Retrieves all users, whom the querying user hasn't liked and the expert system isn't trained on yet
    :param db: db instance
    :param userid: id of current user
    :return: a list of users
    """
    statement = (select(User).join(SwipeStatus, onclause=and_(or_(SwipeStatus.user1_id == User.id,
                SwipeStatus.user2_id == User.id), SwipeStatus.status == SwipeStatusType.view))
                 .where(and_(SwipeStatus.used_for_model == False,
                             and_(User.id != userid, SwipeStatus.user1_id == userid))))

    user_list = db.exec(statement).all()

    return user_list