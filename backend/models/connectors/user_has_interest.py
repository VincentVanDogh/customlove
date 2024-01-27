from typing import Optional

from sqlmodel import SQLModel, Field


class UserHasInterest(SQLModel, table=True):
    user_id: Optional[int] = Field(
        default=None, foreign_key="user.id", primary_key=True
    )
    interest_id: Optional[int] = Field(
        default=None, foreign_key="interest.id", primary_key=True
    )
