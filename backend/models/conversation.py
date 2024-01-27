from typing import Optional, Any
from sqlmodel import SQLModel, Field, Relationship
from backend.models.user import User


class Conversation(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    user1_id: int = Field(foreign_key="user.id")
    user2_id: int = Field(foreign_key="user.id")

    conversation_user1: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Conversation.user1_id==User.id",
        "lazy": "joined",
    })

    conversation_user2: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Conversation.user2_id==User.id",
        "lazy": "joined",
    })
