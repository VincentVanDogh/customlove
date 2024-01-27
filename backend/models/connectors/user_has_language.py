from typing import Optional

from sqlmodel import SQLModel, Field


class UserHasLanguage(SQLModel, table=True):
    user_id: Optional[int] = Field(
        default=None, foreign_key="user.id", primary_key=True
    )
    language_id: Optional[int] = Field(
        default=None, foreign_key="language.id", primary_key=True
    )
