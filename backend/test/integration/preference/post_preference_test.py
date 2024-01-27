from starlette import status

from backend.test.integration.fixtures import client_fixture as client, session_fixture as session

def test_post_create_preference(client, session):
    response = client.post("/preferences/",
                           json={"property_1": "property2", "property_2": "property5", "decision": "decision2", "date": "2023-11-13T13:54:16.479289"})

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['id'] is not None
