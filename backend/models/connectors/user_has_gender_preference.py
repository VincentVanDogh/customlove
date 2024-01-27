from typing import Optional

from sqlmodel import SQLModel, Field


class UserHasGenderPreference(SQLModel, table=True):
    user_id: Optional[int] = Field(
        default=None, foreign_key="user.id", primary_key=True
    )
    gender_identity_id: Optional[int] = Field(
        default=None, foreign_key="gender_identity.id", primary_key=True
    )
