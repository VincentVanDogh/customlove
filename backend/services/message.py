import json
from typing import Annotated

from fastapi import Depends
from fastapi_pagination.ext.sqlmodel import paginate
from sqlalchemy import or_, and_
from sqlmodel import Session, select, col
from starlette.requests import Request
from starlette.responses import HTMLResponse

from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.not_found_exception import NotFoundException
from backend.models.conversation import Conversation
from backend.models.message import Message
from backend.models.user import User
from backend.repository.repository import create_session
from backend.utils.pagination import PaginationParams
from backend.utils.token import get_current_user, create_access_token


def get_messages(conversation_id: int, db: Annotated[Session, Depends(create_session)],
                 user: Annotated[User, Depends(get_current_user)], request: Request):
    conversation = (db.exec(select(Conversation).
                            where(Conversation.id == conversation_id))).first()

    if conversation is None:
        raise NotFoundException(f"Conversation #{conversation_id} not found")

    # raise exception if the user is unauthorized for that conversation
    if conversation.user1_id != user.id and conversation.user2_id != user.id:
        raise CredentialsException('Unauthorized')

    # return the messages in descending order
    return paginate(db, select(Message).where(Message.conversation_id == conversation.id).order_by(
        col(Message.timestamp).desc()), PaginationParams(size=request.query_params.get("size"),
                                               page=request.query_params.get("page")))


def _save_message(message: Message, db: Annotated[Session, Depends(create_session)]):
    """
    to be used only in the websockets flow
    """
    conversation = db.exec(select(Conversation).
                           where(Conversation.id == message.conversation_id)).first()

    # raise exception if one of the users is unauthorized for that conversation
    if (conversation.user1_id != message.sender_id and conversation.user2_id != message.sender_id) or \
            (conversation.user1_id != message.receiver_id and conversation.user2_id != message.receiver_id):
        raise CredentialsException('Unauthorized')

    db.add(message)
    db.commit()
    db.refresh(message)
    return message


# region sockets_test: this will be deleted as soon as the frontend-chat functionality is ready
def sockets_test(username: str, receiver_username: str, db: Annotated[Session, Depends(create_session)]):
    """
    this is just for texting, will be deleted as soon as the frontend-chat functionality is ready
    """
    user = db.exec(select(User).where(User.email == username)).first()
    if user is None:
        raise CredentialsException('User not found')

    receiver = db.exec(select(User).where(User.email == receiver_username)).first()
    if receiver is None:
        raise CredentialsException('Receiver not found')

    access_token = create_access_token(data={"sub": username})
    conversation = db.exec(select(Conversation).
                           where(or_(and_(Conversation.user1_id == user.id, Conversation.user2_id == receiver.id),
                                     and_(Conversation.user1_id == receiver.id, Conversation.user2_id == user.id)))).first()
    if conversation is None:
        raise NotFoundException(f"No conversations between {user.email} and {receiver.email} found")

    html = """
    <!DOCTYPE html>
    <html>
        <head>
            <title>Chat</title>
        </head>
        <body>
            <h1>WebSocket Chat</h1>
            <h2>Your ID: <span id="ws-id">%%SENDER_ID%%</span></h2>
            <form action="" onsubmit="sendMessage(event)">
                <input type="text" id="messageText" autocomplete="off"/>
                <button>Send</button>
            </form>
            <ul id='messages'>
            </ul>
            <script>
                var ws = new WebSocket("%%URL%%/users/socket/%%TOKEN%%");
                ws.onmessage = function(event) {
                    var messages = document.getElementById('messages')
                    var message = document.createElement('li')
                    var content = document.createTextNode(event.data)
                    message.appendChild(content)
                    messages.appendChild(message)
                };
                function sendMessage(event) {
                    var input = document.getElementById("messageText")
                    var content = JSON.stringify(
                        {
                            "type": "message",
                            "content": {
                                "conversation_id": %%CONVERSATION_ID%%,
                                "sender_id": %%SENDER_ID%%, 
                                "receiver_id": %%RECEIVER_ID%%, 
                                "message": input.value
                            }
                        }
                    )
                    console.log(content)
                    ws.send(content)
                    input.value = ''
                    event.preventDefault()
                }
            </script>
        </body>
    </html>
    """

    url = "wss://23ws-ase-pr-inso-06.apps.student.inso-w.at/develop/backend"
    with open('backend/database.json') as file:
        connection_string = json.load(file)
        if "127.0.0.1" in connection_string['address'] or "localhost" in connection_string['address']:
            url = "ws://127.0.0.1:8000"

    return HTMLResponse(html.
                        replace("%%SENDER_ID%%", str(user.id)).
                        replace("%%RECEIVER_ID%%", str(receiver.id)).
                        replace("%%CONVERSATION_ID%%", str(conversation.id)).
                        replace("%%URL%%", url).
                        replace("%%TOKEN%%", access_token))

# endregion
