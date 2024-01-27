from backend.models.interest import Interest
from backend.responses.user_response import UserResponse, UserResponseWithInterestsAndDistance


def map_user_to_user_response_with_interests(user, distance) -> UserResponseWithInterestsAndDistance:
    user_interests = [Interest(id=interest.id, name=interest.name, icon=interest.icon) for interest in user.interests]
    return UserResponseWithInterestsAndDistance(
        id=user.id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        bio=user.bio,
        date_of_birth=user.date_of_birth,
        job=user.job,
        search_radius=user.search_radius,
        matching_algorithm=user.matching_algorithm,
        swipes_left=user.swipes_left,
        swipe_limit_reset_date=user.swipe_limit_reset_date,
        latitude=user.latitude,
        longitude=user.longitude,
        gender_identity_id=user.gender_identity_id,
        interests=user_interests,
        distance=distance
    )


def map_user_to_user_response(user) -> UserResponse:
    return UserResponse(
        id=user.id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        bio=user.bio,
        date_of_birth=user.date_of_birth,
        job=user.job,
        search_radius=user.search_radius,
        matching_algorithm=user.matching_algorithm,
        swipes_left=user.swipes_left,
        swipe_limit_reset_date=user.swipe_limit_reset_date,
        latitude=user.latitude,
        longitude=user.longitude,
        gender_identity_id=user.gender_identity_id
    )
