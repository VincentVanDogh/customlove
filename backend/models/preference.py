from datetime import datetime
from typing import Optional, List, TYPE_CHECKING

from sqlmodel import SQLModel, Field, Relationship

from .connectors.user_has_preference import UserHasPreference

if TYPE_CHECKING:
    from .user import User


class Preference(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    property_1: str
    property_2: str
    decision: str
    date: datetime

    users: List["User"] = Relationship(back_populates="preferences", link_model=UserHasPreference)
