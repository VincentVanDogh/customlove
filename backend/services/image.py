from datetime import datetime
from typing import Annotated, List

from fastapi import Depends, UploadFile
from sqlalchemy import LargeBinary
from sqlmodel import Session, select, or_, and_

from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.not_found_exception import NotFoundException
from backend.models.conversation import Conversation
from backend.models.image import Image, ProfilePicture
from backend.models.message import Message
from backend.models.user import User
from backend.repository.repository import create_session
from backend.responses.notification import Notification, NotificationType
from backend.utils.token import get_current_user
from fastapi import Response
from backend.utils.connection_manager import connection_manager


def get_image(user: Annotated[User, Depends(get_current_user)],
              db: Annotated[Session, Depends(create_session)], image_id: int):
    image = db.exec(select(Image).where(Image.id == image_id)).first()

    if image is None:
        raise NotFoundException(f"Image with id: #{image_id} not found")

    if image.conversation.user2_id != user.id and image.conversation.user1_id != user.id:
        raise CredentialsException("Unauthorized call")

    return Response(content=image.content, media_type=image.content_type)


async def post_image(receiver_id: int, user: Annotated[User, Depends(get_current_user)],
                     db: Annotated[Session, Depends(create_session)], file: UploadFile):
    # get the targeted conversation
    conversation = db.exec(select(Conversation).where(
        or_(
            and_(Conversation.user1_id == user.id, Conversation.user2_id == receiver_id),
            and_(Conversation.user1_id == receiver_id, Conversation.user2_id == user.id)
        )
    )).first()

    # raise error, when no conversation between the target users exist
    if conversation is None:
        raise NotFoundException(f"No conversation between the users: #{receiver_id} and #{user.id} found")

    image = Image(conversation_id=conversation.id, content=file.file.read(), filename=file.filename, content_type=file.content_type)

    # add the image to the db
    db.add(image)
    db.commit()
    db.refresh(image)

    # create a corresponding message object
    message = Message(
        is_image=True,
        conversation_id=conversation.id,
        sender_id=user.id,
        receiver_id=receiver_id,
        message=str(image.id),
        timestamp=datetime.now()
    )

    # add the message object to the db
    db.add(message)
    db.commit()
    db.refresh(message)

    # prepare a notification object
    notification = Notification.factory(message)

    # send the notification to the receiver and sender
    await connection_manager.send_notification(message.receiver_id, notification)
    await connection_manager.send_notification(message.sender_id, notification)

    return message
