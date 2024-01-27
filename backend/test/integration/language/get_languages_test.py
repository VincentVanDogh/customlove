from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import language, load_entities


def test_get_languages(client, session):
    languages = [language("english"), language("german")]
    load_entities(languages, session)

    response = client.get("/languages/")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 2
    assert response.json()['items'][0]['id'] == languages[0].id
    assert response.json()['items'][1]['id'] == languages[1].id
