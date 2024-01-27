from typing import TYPE_CHECKING, Optional

from sqlmodel import SQLModel, Field, Relationship

if TYPE_CHECKING:
    from .user import User


class Rating(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    rating_user_id: Optional[int] = Field(default=None, foreign_key="user.id")
    rated_user_id: Optional[int] = Field(default=None, foreign_key="user.id")
    is_safe: bool

    ratings_given: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Rating.rating_user_id==User.id",
        "lazy": "joined",
    })

    ratings_received: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Rating.rated_user_id==User.id",
        "lazy": "joined",
    })