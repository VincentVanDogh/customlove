from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import gender_identity, load_entities


def test_get_gender_identity_by_id(client, session):
    identity = gender_identity("woman")
    load_entities([identity], session)

    response = client.get(f"/gender-identities/{identity.id}")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] == identity.id


def test_get_gender_identity_by_id_non_existent(client, session):
    response = client.get(f"/gender-identities/1")

    assert response.status_code == status.HTTP_404_NOT_FOUND
