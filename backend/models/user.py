from datetime import date
from datetime import datetime
from typing import TYPE_CHECKING, Optional

from shapely import geometry, wkt
from sqlmodel import SQLModel, Field, Relationship

from .connectors.user_has_gender_preference import UserHasGenderPreference
from .connectors.user_has_interest import UserHasInterest
from .connectors.user_has_language import UserHasLanguage
from .connectors.user_has_preference import UserHasPreference

if TYPE_CHECKING:
    from .language import Language
    from .gender_identity import GenderIdentity
    from .interest import Interest
    from .preference import Preference
    from .expert_system import ExpertSystem


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    first_name: str
    last_name: str
    email: str
    password: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    matching_algorithm: int
    swipes_left: int
    swipe_limit_reset_date: datetime
    latitude: Optional[float]
    longitude: Optional[float]

    location: Optional[str]

    gender_identity_id: Optional[int] = Field(default=None, foreign_key="gender_identity.id")

    gender_identity: Optional["GenderIdentity"] = Relationship(back_populates="user_gender_identity")
    languages: Optional["Language"] = Relationship(back_populates="users", link_model=UserHasLanguage)
    gender_preferences: Optional["GenderIdentity"] = Relationship(back_populates="users",
                                                                  link_model=UserHasGenderPreference)
    interests: Optional["Interest"] = Relationship(back_populates="users", link_model=UserHasInterest)
    preferences: Optional["Preference"] = Relationship(back_populates="users", link_model=UserHasPreference)
    expert_system: Optional["ExpertSystem"] = Relationship(back_populates="users")

    @property
    def generate_location(self):
        if self.latitude is not None and self.longitude is not None:
            point = geometry.Point(self.longitude, self.latitude)
            return wkt.dumps(point)
        else:
            return None

    def set_location(self):
        self.location = self.generate_location

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Automatically set location when initializing the object
        self.set_location()

    class Config:
        arbitrary_types_allowed = True

    def get_age(self):
        """
        Calculates the users age by providing a datetime
        param: user
        returns users age
        """
        today = date.today()
        return today.year - self.date_of_birth.year - ((today.month, today.day) < (self.date_of_birth.month,
                                                                                   self.date_of_birth.day))
