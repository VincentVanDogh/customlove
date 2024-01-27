from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient

from backend.models.conversation import Conversation
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities, RAW_PASSWORD, login, \
    authorized_request, user_gamma
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_get_matches(client: TestClient, session: Session):
    users = [user_alfa(), user_beta(), user_gamma()]
    load_entities(users, session)

    match1 = SwipeStatus(user1_id=users[0].id, user2_id=users[1].id, status=SwipeStatusType.match)
    match2 = SwipeStatus(user1_id=users[0].id, user2_id=users[2].id, status=SwipeStatusType.match)
    conv = Conversation(user1_id=users[0].id, user2_id=users[2].id)

    load_entities([match1, match2, conv], session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.get, f'/swipe_statuses/matches')

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 1
    assert response.json()['items'][0]['id'] == match1.id
    assert response.json()['items'][0]['user1_id'] == users[0].id
    assert response.json()['items'][0]['user2_id'] == users[1].id
