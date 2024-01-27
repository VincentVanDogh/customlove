from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import interest, load_entities


def test_get_interest_by_id(client, session):
    sports = interest("sports")
    load_entities([sports], session)

    response = client.get(f"/interests/{sports.id}")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] == sports.id


def test_get_interest_by_id_non_existent(client, session):
    response = client.get(f"/interests/1")

    assert response.status_code == status.HTTP_404_NOT_FOUND
