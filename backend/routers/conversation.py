from typing import Annotated  #
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status
from backend.models.conversation import Conversation
from backend.responses.error_response import ErrorResponse
from backend.services.conversation import get_conversations, post_conversation

router = APIRouter(prefix='/conversations', tags=['conversations'], responses={
    status.HTTP_200_OK: {"description": "Success"},
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})


@router.get("/", response_model=Page[Conversation])
def get_conversations(commons: Annotated[Page[Conversation], Depends(get_conversations)]):
    return commons


@router.post("/{user_id}", response_model=Conversation)
def post_conversation(commons: Annotated[Conversation, Depends(post_conversation)]):
    return commons
