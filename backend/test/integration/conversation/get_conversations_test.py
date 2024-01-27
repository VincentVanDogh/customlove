from fastapi.testclient import TestClient
from sqlmodel import Session
from starlette import status
from backend.models.conversation import Conversation
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta, authorized_request, login, \
    RAW_PASSWORD


def test_get_owners_conversations(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    conversation = Conversation(user1_id=users[0].id, user2_id=users[1].id)
    load_entities([conversation], session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/conversations")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['items'][0]['id'] == conversation.id


def test_get_recipients_conversations(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    conversation = Conversation(user1_id=users[0].id, user2_id=users[1].id)
    load_entities([conversation], session)

    token = login(users[1].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/conversations")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['items'][0]['id'] == conversation.id
