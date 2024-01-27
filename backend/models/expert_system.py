from typing import Optional, TYPE_CHECKING
from sqlmodel import SQLModel, Field, Relationship

if TYPE_CHECKING:
    from .user import User


class ExpertSystem(SQLModel, table=True):
    __tablename__ = "expert_system"
    id: Optional[int] = Field(default=None, primary_key=True)
    # TODO: Remove Optional, default and nullable
    model: Optional[bytes] = Field(default=None, nullable=True)
    users: Optional["User"] = Relationship(back_populates="expert_system")
    user_id: Optional[int] = Field(default=None, foreign_key="user.id")




