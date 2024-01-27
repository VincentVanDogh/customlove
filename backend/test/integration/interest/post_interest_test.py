from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_post_interest(client, session):
    response = client.post("/interests/", json={"name": "theater", "icon": "icon6"})

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] is not None
    assert response.json()['name'] == "theater"
