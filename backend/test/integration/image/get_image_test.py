from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient

from backend.models.conversation import Conversation
from backend.models.image import Image
from backend.test.integration.test_utils import user_alfa, user_beta, user_gamma
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta, authorized_request, login, \
    RAW_PASSWORD

def test_get_image_non_existent(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/images/2")

    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_get_image_unauthorized(client: TestClient, session: Session):
    users = [user_alfa(), user_beta(), user_gamma()]
    load_entities(users, session)

    conversation = Conversation(user1_id=users[0].id, user2_id=users[1].id)
    load_entities([conversation], session)

    image = Image(
        conversation_id=conversation.id,
        content=b'12345',
        filename="test.jpg",
        content_type="image/jpeg"
    )
    load_entities([image], session)

    token = login(users[2].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, f"/images/{image.id}")

    assert response.status_code == status.HTTP_401_UNAUTHORIZED


def test_get_image(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    conversation = Conversation(user1_id=users[0].id, user2_id=users[1].id)
    load_entities([conversation], session)

    image = Image(
        conversation_id=conversation.id,
        content=b'12345',
        filename="test.jpg",
        content_type="image/jpeg"
    )
    load_entities([image], session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, f"/images/{image.id}")

    assert response.status_code == status.HTTP_200_OK
