from datetime import datetime, timedelta
from fastapi.testclient import TestClient
from sqlmodel import Session
from starlette import status

from backend.models.conversation import Conversation
from backend.models.message import Message
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities, login, RAW_PASSWORD, \
    authorized_request


def test_get_messages_conversation_not_found(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/messages/1")

    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_get_messages_unauthorized_users(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)

    conversation = Conversation(user1_id=2, user2_id=3)
    load_entities([conversation], session)

    response = authorized_request(token, client, lambda c: c.get, "/messages/1")

    assert response.status_code == status.HTTP_401_UNAUTHORIZED


def test_get_messages_conversation_owner(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)

    conversation = Conversation(user1_id=users[0].id, user2_id=users[1].id)
    load_entities([conversation], session)

    response = authorized_request(token, client, lambda c: c.get, "/messages/1")

    assert response.status_code == status.HTTP_200_OK


def test_get_messages_conversation_recipient(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)

    conversation = Conversation(user1_id=users[1].id, user2_id=users[0].id)
    load_entities([conversation], session)

    response = authorized_request(token, client, lambda c: c.get, "/messages/1")

    assert response.status_code == status.HTTP_200_OK


def test_get_messages_return_earliest_messages(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)

    conversation = Conversation(user1_id=users[1].id, user2_id=users[0].id)
    load_entities([conversation], session)

    m1 = Message(conversation_id=conversation.id, sender_id=users[1].id, receiver_id=users[0].id,
                 timestamp=datetime.now() - timedelta(seconds=10), message="old")
    m2 = Message(conversation_id=conversation.id, sender_id=users[1].id, receiver_id=users[0].id,
                 timestamp=datetime.now(), message="newest")
    load_entities([m1, m2], session)

    response = authorized_request(token, client, lambda c: c.get, "/messages/1")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 2
    assert response.json()['items'][0]['id'] == m2.id
    assert response.json()['items'][1]['id'] == m1.id
