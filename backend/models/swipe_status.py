import enum
from typing import TYPE_CHECKING, Optional

from sqlmodel import SQLModel, Field, Relationship, Enum, Column

if TYPE_CHECKING:
    from .user import User


class SwipeStatusType(str, enum.Enum):
    view = "view"
    like = "like"
    match = "match"


class SwipeStatus(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    user1_id: int = Field(default=None, foreign_key="user.id")
    user2_id: int = Field(default=None, foreign_key="user.id")
    used_for_model: bool = Field(default=False)
    status: SwipeStatusType = Field(sa_column=Column(Enum(SwipeStatusType)))

    match_user1: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "SwipeStatus.user1_id==User.id",
        "lazy": "joined",
    })

    match_user2: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "SwipeStatus.user2_id==User.id",
        "lazy": "joined",
    })
