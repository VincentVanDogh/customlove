from typing import Optional, List, TYPE_CHECKING

from sqlmodel import SQLModel, Field, Relationship

from .connectors.user_has_interest import UserHasInterest

if TYPE_CHECKING:
    from .user import User


class Interest(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    icon: str

    users: List["User"] = Relationship(back_populates="interests", link_model=UserHasInterest)

    def __hash__(self):
        return hash((self.icon, self.name))

    def __eq__(self, other):
        if not isinstance(other, type(self)):
            return False
        return (self.icon, self.name) == (other.icon, other.name)
