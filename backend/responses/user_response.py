from datetime import datetime
from typing import Optional

from pydantic import BaseModel

from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language


class UserResponseWithInterestsAndDistance(BaseModel):
    id: Optional[int] = None
    first_name: str
    last_name: str
    email: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    matching_algorithm: int
    swipes_left: int
    swipe_limit_reset_date: datetime
    latitude: Optional[float]
    longitude: Optional[float]
    gender_identity_id: Optional[int] = None
    interests: list[Interest]
    distance: Optional[int]


class UserResponse(BaseModel):
    id: Optional[int] = None
    first_name: str
    last_name: str
    email: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    matching_algorithm: int
    swipes_left: int
    swipe_limit_reset_date: datetime
    latitude: Optional[float]
    longitude: Optional[float]
    gender_identity_id: Optional[int] = None


class UserDetailedResponse(BaseModel):
    id: int
    first_name: str
    last_name: str
    email: str
    password: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    gender_identity: GenderIdentity
    gender_preferences: list[GenderIdentity]
    swipes_left: int
    swipe_limit_reset_date: datetime
    latitude: float
    longitude: float
    interests: list[Interest]
    languages: list[Language]
    matching_algorithm: int
    profile_picture_id: Optional[int]


class ProfileResponse(BaseModel):
    user: UserDetailedResponse
    genders: list[GenderIdentity]
    interests: list[Interest]
    languages: list[Language]
