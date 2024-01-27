from typing import Annotated
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status
from backend.models.preference import Preference
from backend.responses.error_response import ErrorResponse
from backend.services.preference import get_preference, get_preferences, post_preference

router = APIRouter(prefix='/preferences', tags=['preferences'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get("/", response_model=Page[Preference])
async def get_preferences(commons: Annotated[Page[Preference], Depends(get_preferences)]):
    """
    Return a paginated list of preferences
    :return: a paginated list of preferences
    """
    return commons


@router.get('/{preference_id}', response_model=Preference, responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
})
def get_preference(commons: Annotated[dict, Depends(get_preference)]):
    """
    Return a specific preference
    :return: a preference object
    """
    return commons


@router.post('/', response_model=Preference)
def post_preference(commons: Annotated[dict, Depends(post_preference)]):
    """
    Create a preference
    :return: a preference object
    """
    return commons
