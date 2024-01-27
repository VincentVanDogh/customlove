from sqlmodel import Session, select
from starlette.testclient import TestClient
from backend.models.conversation import Conversation
from backend.models.message import Message, message_factory
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities, login, RAW_PASSWORD
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
import pytest
import asyncio


@pytest.mark.asyncio
async def test_ws_messages_save_in_the_db(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)

    conversation = Conversation(user1_id=users[1].id, user2_id=users[0].id)
    load_entities([conversation], session)

    with client.websocket_connect(f"/users/socket/{token}") as websocket:
        websocket.send_text("{\"type\": \"message\", \"content\":"
                            "{" + f""
                                  f"\"conversation_id\": \"{str(conversation.id)}\", "
                                  f"\"sender_id\": \"{str(users[0].id)}\", "
                                  f"\"receiver_id\": \"{str(users[1].id)}\", "
                                  f"\"message\": \"test_message\"" + "}}")
        await asyncio.sleep(5)

        message = session.exec(select(Message)).first()
        assert message is not None
        assert message.message == "test_message"
        assert message.timestamp is not None
