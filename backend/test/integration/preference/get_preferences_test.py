from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import random_preferences, load_entities


def test_get_preferences(client: TestClient, session: Session):
    preferences = random_preferences(2)
    load_entities(preferences, session)

    response = client.get("/preferences/")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 2
    assert response.json()['items'][0]['id'] == preferences[0].id
    assert response.json()['items'][1]['id'] == preferences[1].id
