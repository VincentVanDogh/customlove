from fastapi.testclient import TestClient
from sqlmodel import Session
from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta, login, RAW_PASSWORD, \
    authorized_request


def test_get_users(client: TestClient, session: Session):
    user = user_alfa()
    load_entities([user], session)
    user1_token = login(user.email, RAW_PASSWORD, client)

    response = authorized_request(user1_token, client, lambda c: c.get, f'/users/{user.id}')

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] == user.id
