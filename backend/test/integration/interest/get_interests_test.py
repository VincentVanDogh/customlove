from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import interest, load_entities


def test_get_interests(client, session):
    interests = [interest("sports"), interest("movies")]
    load_entities(interests, session)

    response = client.get("/interests/")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 2
    assert response.json()['items'][0]['id'] == interests[0].id
    assert response.json()['items'][1]['id'] == interests[1].id
