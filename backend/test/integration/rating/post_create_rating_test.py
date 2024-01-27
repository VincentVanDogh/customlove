from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities


def test_post_create_rating(client, session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    response = client.post("/ratings/",
                           json={"rating_user_id": users[0].id, "rated_user_id": users[1].id, "is_safe": True})

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] is not None
