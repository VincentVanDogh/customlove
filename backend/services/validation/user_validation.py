import re
from datetime import date, datetime

from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.user import User
from backend.requests.user_request import UserRegistration


def validate_new_user(
        first_name: str,
        last_name: str,
        email: str,
        bio: str,
        job: str,
        date_of_birth: datetime,
        interests: [Interest],
        gender_preferences: [GenderIdentity],
        search_radius: int
) -> [str]:
    """
    Validates whether a user has valid entries and can be saved within the database.
    :param first_name: first name of the user
    :param last_name: last name of the user
    :param email: email of the user
    :param bio: optional bio of the user
    :param job: optional job of the user
    :param date_of_birth: birthdate of a user
    :param interests: interests of the user
    :param gender_preferences: gender preferences of the user
    :param search_radius: search radius of the user
    :return: list of validation exceptions
    """
    validation_exceptions: [str] = []
    if len(first_name) == 0:
        validation_exceptions.append("First name cannot be empty")
    if len(last_name) == 0:
        validation_exceptions.append("Last name cannot be empty")
    if len(first_name) > 255:
        validation_exceptions.append("First name cannot be longer than 256 characters")
    if len(last_name) > 255:
        validation_exceptions.append("Last name cannot be longer than 256 characters")
    if len(email) > 255:
        validation_exceptions.append("User email cannot be longer than 256 characters")
    if not __is_email_valid(email):
        validation_exceptions.append("Provided an email in an invalid format")
    if bio is not None and len(bio) > 256:
        validation_exceptions.append("Bio cannot be longer than 256 characters")
    if job is not None and len(job) > 256:
        validation_exceptions.append("Job cannot be longer than 256 characters")
    if __is_under_18(date_of_birth):
        validation_exceptions.append("Users under 18 are not allowed on the app")
    if len(interests) < 3 or len(interests) > 5:
        validation_exceptions.append("User requires 3 - 5 interests")
    if len(gender_preferences) < 1:
        validation_exceptions.append("User requires at least 1 gender preference")
    if search_radius < 5 or search_radius > 100:
        validation_exceptions.append("Search radius must be between 5 km and 100 km")
    return validation_exceptions


def __is_email_valid(email: str) -> bool:
    """
    Evaluates whether an email address has a valid format.
    :param email: provided email that will be checked
    :return: true if the email address has a valid format
    """
    return re.fullmatch(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b', email) is not None


def __is_tel_number_valid(tel_number: str) -> bool:
    """
    Evaluates whether a telephone number has a valid format.
    :param tel_number: provided telephone number that will be checked
    :return: true if the telephone number has a valid format
    """
    return re.fullmatch(r'[0-9]{0,14}$', tel_number.replace(" ", "")) is not None


def __is_under_18(birth: date) -> bool:
    """
    Evaluates whether a birthdate is under 18 years.
    :param birth: provided birthdate that will be checked if it is under 18
    :return: true if the birthdate is under 18 years
    """
    now = date.today()
    return (
        now.year - birth.year < 18
        or now.year - birth.year == 18 and (
            now.month < birth.month
            or now.month == birth.month and now.day <= birth.day
        )
    )