from typing import Annotated
from fastapi import Depends
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import select, or_, and_
from sqlmodel import Session
from starlette.requests import Request

from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.models.conversation import Conversation
from backend.repository.repository import create_session
from backend.models.user import User
from backend.responses.notification import Notification
from backend.utils.connection_manager import connection_manager
from backend.utils.pagination import PaginationParams
from backend.utils.token import get_current_user


def get_conversations(user: Annotated[User, Depends(get_current_user)],
                      db: Annotated[Session, Depends(create_session)], request: Request):
    return paginate(db, select(Conversation).where(or_(Conversation.user1_id == user.id,
                                                       Conversation.user2_id == user.id)),
                    PaginationParams(size=request.query_params.get("size"), page=request.query_params.get("page")))


async def post_conversation(user_id: int, user: Annotated[User, Depends(get_current_user)],
                      db: Annotated[Session, Depends(create_session)]):

    if user_id == user.id:
        raise BadRequestException("Creating a conversation with oneself is not allowed")

    recipient = db.exec(select(User).where(User.id == user_id)).first()
    if recipient is None:
        raise NotFoundException(f"User with the provided id: {user_id} does not exist")

    c = db.exec(select(Conversation).where(
        or_(
            and_(Conversation.user1_id==user.id, Conversation.user2_id == recipient.id),
            and_(Conversation.user1_id == recipient.id, Conversation.user2_id == user.id),
        )
    )).first()
    if c is not None:
        raise BadRequestException("This conversation already exists!")

    conversation: Conversation = Conversation(user1_id=user.id, user2_id=user_id)

    db.add(conversation)
    db.commit()
    db.refresh(conversation)

    await connection_manager.send_notification(
        recipient.id,
        Notification(
            {
                "type": "refresh",
                "content": {}
            }
        )
    )

    return conversation
