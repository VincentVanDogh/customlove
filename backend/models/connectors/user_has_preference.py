from typing import Optional

from sqlmodel import SQLModel, Field


class UserHasPreference(SQLModel, table=True):
    user_id: Optional[int] = Field(
        default=None, foreign_key="user.id", primary_key=True
    )
    preference_id: Optional[int] = Field(
        default=None, foreign_key="preference.id", primary_key=True
    )
