from typing import Optional

from sqlalchemy import LargeBinary, Column
from sqlalchemy.dialects.postgresql import BYTEA
from sqlmodel import SQLModel, Field, Relationship

from backend.models.conversation import Conversation
from backend.models.user import User


class Image(SQLModel, table=True):
    __tablename__ = "image"
    id: Optional[int] = Field(default=None, primary_key=True)
    conversation_id: int = Field(default=None, foreign_key="conversation.id")
    content: bytes = Field(default=None, sa_column=Column(LargeBinary))
    filename: str = Field(default=None)
    content_type: str = Field(default=None)

    conversation: Conversation = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Image.conversation_id==Conversation.id",
        "lazy": "joined",
    })


class ProfilePicture(SQLModel, table=True):
    __tablename__ = "profile_picture"
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(default=None, foreign_key="user.id")
    content: bytes = Field(default=None, sa_column=Column(LargeBinary))
    filename: str = Field(default=None)
    content_type: str = Field(default=None)

    user: User = Relationship(sa_relationship_kwargs={
        "primaryjoin": "ProfilePicture.user_id==User.id",
        "lazy": "joined",
    })

