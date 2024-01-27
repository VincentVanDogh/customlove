from typing import Annotated
from fastapi import Depends
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import Session, select, or_, exists, and_, update
from starlette.requests import Request
from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.validation_exception import ValidationException
from backend.models.conversation import Conversation
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.repository.repository import create_session
from backend.responses.notification import Notification
from backend.utils.pagination import PaginationParams
from backend.utils.token import get_current_user
from backend.utils.connection_manager import connection_manager


def get_matches(
        db: Annotated[Session, Depends(create_session)],
        user: Annotated[User, Depends(get_current_user)],
        request: Request
):
    query = select(
        SwipeStatus
    ).where(
        SwipeStatus.status == SwipeStatusType.match,
        or_(SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user.id)
    ).where(
        ~exists(
            select(Conversation).where(
                or_(
                    and_(
                        Conversation.user1_id ==  SwipeStatus.user1_id,
                        Conversation.user2_id == SwipeStatus.user2_id
                    ),
                    and_(
                        Conversation.user1_id == SwipeStatus.user2_id,
                        Conversation.user2_id == SwipeStatus.user1_id
                    )
                )
            )
        )
    )

    return paginate(db, query, PaginationParams(size=request.query_params.get("size"), page=request.query_params.get("page")))


def post_view(
        db: Annotated[Session, Depends(create_session)],
        user: Annotated[User, Depends(get_current_user)],
        user_id: int
) -> SwipeStatus:
    """
    Stores a model object in the database.
    :param db: database provided through dependency injection
    :param user: user currently logged in
    :param user_id: id of the other user
    :return: newly stored match
    """
    if user.id == user_id:
        raise ValidationException("User trying to match him- or herself")

    # We do not need to check whether swipe_status is equal to view, if one already exists between two users, it must be
    # a view or higher
    existing_entry = db.exec(select(SwipeStatus).where(
        SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user_id)).all()

    if len(existing_entry) > 0:
        raise ValidationException("Swipe already exists")

    new_swipe_status = SwipeStatus(
        user1_id=user.id,
        user2_id=user_id,
        status=SwipeStatusType.view
    )

    db.add(new_swipe_status)
    db.commit()
    db.refresh(new_swipe_status)
    return new_swipe_status


async def post_like (
        db: Annotated[Session, Depends(create_session)],
        user: Annotated[User, Depends(get_current_user)],
        user_id: int
):
    """
    Stores a model object in the database.
    :param db: database provided through dependency injection
    :param user: user currently logged in
    :param user_id: id of the other user
    :return: newly stored match
    """
    if user.id == user_id:
        raise ValidationException("Cannot match a person with itself")

    # If entry (user_1, user_2, 'like') exists, corrupt db
    user_1_swipe = db.exec(select(SwipeStatus).where(
        SwipeStatus.user1_id == user.id,
        SwipeStatus.user2_id == user_id,
        SwipeStatus.status == SwipeStatusType.like
    )).all()

    if len(user_1_swipe) > 0:
        raise FatalException("Like/match for user1 to user2 already exists")

    # if a match between user1 and user2 already exists - the db is corrupt
    if db.exec(select(SwipeStatus).where(or_(
            and_(SwipeStatus.user1_id == user_id, SwipeStatus.user2_id == user.id),
            and_(SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user_id)
    )
            , SwipeStatus.status == SwipeStatusType.match)).first() is not None:
        raise FatalException("a match for user1 to user2 already exists")

    user_2_swipe = db.exec(select(SwipeStatus).where(
        and_(SwipeStatus.user1_id == user_id,
             SwipeStatus.user2_id == user.id,
             SwipeStatus.status == SwipeStatusType.like)
    )).all()

    # If there already exists a swipe with status "like" for user_2, the swipe_status is turned to match for both
    if len(user_2_swipe) > 0:
        # Update user_2 swipe_status to match
        user_2_swipe_obj = user_2_swipe[0]
        user_2_swipe_obj.status = SwipeStatusType.match

        db.add(user_2_swipe_obj)
        db.commit()
        db.refresh(user_2_swipe_obj)

        await connection_manager.send_notification(
            user_id,
            Notification(
                {
                    "type": "match",
                    "content": {
                        "user_id": user.id,
                        "match_id": user_2_swipe_obj.id
                    }
                }
            )
        )
        await connection_manager.send_notification(
            user.id,
            Notification(
                {
                    "type": "match",
                    "content": {
                        "user_id": user_id,
                        "match_id": user_2_swipe_obj.id
                    }
                }
            )
        )

        return user_2_swipe_obj
    else:
        new_swipe_status = SwipeStatus(
            user1_id=user.id,
            user2_id=user_id,
            status=SwipeStatusType.like
        )
        db.add(new_swipe_status)
        db.commit()
        db.refresh(new_swipe_status)
        return new_swipe_status

def set_swipe_status_trained_for_model_true(db, user):
    """
      Sets all used_for_training flags of view or like instances , outgoing of user.id to true
      :param db: db instance
      :param user: current user
      :return: a list of users
      """
    update_statement = (
        update(SwipeStatus).
        where(
            and_(SwipeStatus.used_for_model == False,
            and_(or_(SwipeStatus.status == SwipeStatusType.view,
                    SwipeStatus.status == SwipeStatusType.like),
                SwipeStatus.user1_id == user.id
            ))
        ).
        values(used_for_model = True)

    )


    # Execute the update statement and fetch the updated rows
    db.execute(update_statement)

