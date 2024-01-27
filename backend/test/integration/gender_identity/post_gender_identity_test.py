from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_post_gender_identity(client, session):
    response = client.post(f"/gender-identities", json={"name": "divers"})

    assert response.status_code == 200
    assert response.json()['id'] is not None
    assert response.json()['name'] == "divers"
