from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities, login, RAW_PASSWORD, \
    authorized_request
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_post_like_no_match1(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.post, f'/swipe_statuses/like/{users[1].id}')

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] is not None
    assert response.json()['status'] == SwipeStatusType.like


def test_post_like_no_match2(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    match = SwipeStatus(user1_id=users[1].id, user2_id=users[0].id, status=SwipeStatusType.view)
    load_entities([match], session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.post, f'/swipe_statuses/like/{users[1].id}')

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] is not None
    assert response.json()['status'] == SwipeStatusType.like


def test_post_like_its_a_match(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    match = SwipeStatus(user1_id=users[1].id, user2_id=users[0].id, status=SwipeStatusType.like)
    load_entities([match], session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.post, f'/swipe_statuses/like/{users[1].id}')

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] is not None
    assert response.json()['status'] == SwipeStatusType.match


def test_post_like_to_oneself(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.post, f'/swipe_statuses/like/{users[0].id}')

    assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY


def test_post_like_match_already_exists1(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    match = SwipeStatus(user1_id=users[1].id, user2_id=users[0].id, status=SwipeStatusType.match)
    load_entities([match], session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.post, f'/swipe_statuses/like/{users[1].id}')

    assert response.status_code == status.HTTP_500_INTERNAL_SERVER_ERROR


def test_post_like_match_already_exists2(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    match = SwipeStatus(user1_id=users[0].id, user2_id=users[1].id, status=SwipeStatusType.match)
    load_entities([match], session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.post, f'/swipe_statuses/like/{users[1].id}')

    assert response.status_code == status.HTTP_500_INTERNAL_SERVER_ERROR
