from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, random_preferences


def test_get_preference_by_id(client: TestClient, session: Session):
    preferences = random_preferences(1)
    load_entities(preferences, session)

    response = client.get(f"/preferences/{preferences[0].id}")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] == preferences[0].id


def test_get_preference_by_id_non_existent(client: TestClient, session: Session):
    response = client.get(f"/preferences/1")

    assert response.status_code == status.HTTP_404_NOT_FOUND
