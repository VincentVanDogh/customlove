from typing import Optional, List, TYPE_CHECKING

from sqlmodel import SQLModel, Field, Relationship

from .connectors.user_has_gender_preference import UserHasGenderPreference

if TYPE_CHECKING:
    from .user import User


class GenderIdentity(SQLModel, table=True):
    __tablename__ = "gender_identity"
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str

    users: List["User"] = Relationship(back_populates="gender_preferences", link_model=UserHasGenderPreference)
    user_gender_identity: List["User"] = Relationship(back_populates="gender_identity")
