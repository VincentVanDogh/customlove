from datetime import datetime

from starlette import status

from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.rating import Rating
from backend.models.user import User
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.models.preference import Preference
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities


def test_get_rating_by_id(client, session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    rating1 = Rating(rating_user_id=users[0].id, rated_user_id=users[1].id, is_safe=True)
    load_entities([rating1], session)

    response = client.get(f"/ratings/{rating1.id}")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] == rating1.id
