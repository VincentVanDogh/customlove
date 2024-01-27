from fastapi.testclient import TestClient
from sqlmodel import Session
from starlette import status

from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta, RAW_PASSWORD, login, \
    authorized_request


def test_get_users(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    m = SwipeStatus(user1_id=users[0].id, user2_id=users[1].id, status=SwipeStatusType.match)
    load_entities([m], session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/users")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 1
