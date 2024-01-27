from typing import Optional, List, TYPE_CHECKING

from sqlmodel import SQLModel, Field, Relationship

from backend.models.connectors.user_has_language import UserHasLanguage

if TYPE_CHECKING:
    from .user import User


class Language(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str

    users: List["User"] = Relationship(back_populates="languages", link_model=UserHasLanguage)
