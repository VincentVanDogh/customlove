from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient

from backend.models.conversation import Conversation
from backend.test.integration.test_utils import user_alfa, user_beta
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta, authorized_request, login, \
    RAW_PASSWORD


def test_post_image_no_conversation(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    files = {"file": ("filename.jpg", b'12345', "image/jpeg")}
    response = authorized_request(token, client, lambda c: c.post, "/images?receiver_id=2", files=files)

    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_post_image(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    conversation = Conversation(user1_id=users[0].id, user2_id=users[1].id)
    load_entities([conversation], session)

    token = login(users[0].email, RAW_PASSWORD, client)
    files = {"file": ("filename.jpg", b'12345', "image/jpeg")}
    response = authorized_request(token, client, lambda c: c.post, "/images?receiver_id=2", files=files)

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['message'] == "1"
