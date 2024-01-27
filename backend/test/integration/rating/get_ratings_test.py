from starlette import status

from backend.models.rating import Rating
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities


def test_get_all_ratings(client, session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    rating1 = Rating(rating_user_id=users[0].id, rated_user_id=users[1].id, is_safe=True)
    rating2 = Rating(rating_user_id=users[1].id, rated_user_id=users[0].id, is_safe=False)
    load_entities([rating1, rating2], session)

    response = client.get("/ratings/")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 2
    assert response.json()['items'][0]['id'] == rating1.id
    assert response.json()['items'][1]['id'] == rating2.id
