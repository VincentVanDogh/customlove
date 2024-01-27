from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class UserUpdate(BaseModel):
    latitude: float = Field(None, title="Latitude")
    longitude: float = Field(None, title="Longitude")
    swiped: bool = Field(None, title="Swiped")
    algo_id: int = Field(None, title="AlgoId")


class UserUpdateProfile(BaseModel):
    job: Optional[str]
    bio: Optional[str]
    interest_ids: Optional[list[int]]
    gender_preference_ids: Optional[list[int]]
    language_ids: Optional[list[int]]
    search_radius: Optional[int]


class UserRegistration(BaseModel):
    first_name: str
    last_name: str
    email: str
    password: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    gender_identity_id: int
    gender_preference_ids: list[int]
    latitude: float
    longitude: float
    interest_ids: list[int]
    language_ids: list[int]
    matching_algorithm: int

