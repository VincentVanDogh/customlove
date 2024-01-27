from fastapi.testclient import TestClient
from sqlmodel import Session, select
from starlette import status
from backend.models.conversation import Conversation
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta, authorized_request, login, \
    RAW_PASSWORD


def test_post_conversations(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.post, f"/conversations/{users[1].id}")

    conversation = session.exec(select(Conversation).
                                where(Conversation.user1_id == users[0].id,
                                      Conversation.user2_id == users[1].id)).first()

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] is not None
    assert response.json()['user1_id'] == users[0].id
    assert response.json()['user2_id'] == users[1].id

    assert conversation is not None
    assert conversation.id == response.json()['id']


def test_post_conversations_non_existent_user(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.post, f"/conversations/{users[0].id + 1}")

    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_post_conversations_with_oneself(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.post, f"/conversations/{users[0].id}")

    assert response.status_code == status.HTTP_400_BAD_REQUEST

def test_post_existing_conversation(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    conversation = Conversation(user1_id=users[0].id, user2_id=users[1].id)
    load_entities([conversation], session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.post, f"/conversations/{users[1].id}")

    assert response.status_code == status.HTTP_400_BAD_REQUEST
