from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import gender_identity, load_entities


def test_get_gender_identities(client, session):
    identities = [gender_identity("woman"), gender_identity("alien")]
    load_entities(identities, session)

    response = client.get("/gender-identities")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 2
    assert response.json()['items'][0]['id'] == identities[0].id
    assert response.json()['items'][1]['id'] == identities[1].id
