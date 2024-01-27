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
from backend.utils.token import get_current_user
from fastapi import Response


def get_profile_picture(db: Annotated[Session, Depends(create_session)], user_id: int | None = None):
    if user_id is None:
        return [element.id for element in db.exec(select(ProfilePicture).where(ProfilePicture.user_id == user_id)).all()]

    image = db.exec(select(ProfilePicture).where(ProfilePicture.user_id == user_id)).first()

    if image is None:
        raise NotFoundException(f"Image of user with Id: #{user_id} was not found")

    return Response(content=image.content, media_type=image.content_type)


def post_profile_picture(user: Annotated[User, Depends(get_current_user)],
                     db: Annotated[Session, Depends(create_session)], file: UploadFile):
    image = ProfilePicture(
        user_id=user.id,
        content=file.file.read(),
        filename=file.filename,
        content_type=file.content_type
    )

    db.add(image)
    db.commit()
    db.refresh(image)

    return {"description": "Success"}


def put_profile_picture(
        user: Annotated[User, Depends(get_current_user)],
        db: Annotated[Session, Depends(create_session)],
        file: UploadFile,
):
    profile_picture: ProfilePicture = db.exec(select(ProfilePicture).where(ProfilePicture.user_id == user.id)).first()
    profile_picture.content = file.file.read()
    profile_picture.filename = file.filename
    profile_picture.content_type = file.content_type

    db.add(profile_picture)
    db.commit()
    db.refresh(profile_picture)

    return {"description": "Success"}
