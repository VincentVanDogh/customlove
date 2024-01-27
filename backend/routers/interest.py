from typing import Annotated
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status
from backend.models.interest import Interest
from backend.responses.error_response import ErrorResponse
from backend.services.interest import get_interest, get_interests, post_interest

router = APIRouter(prefix='/interests', tags=['interests'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get("/", response_model=Page[Interest])
async def get_interests(commons: Annotated[Page[Interest], Depends(get_interests)]):
    """
    Return a paginated list of interests
    :return: a paginated list of interests
    """
    return commons


@router.get('/{interest_id}', response_model=Interest, responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
})
def get_interest(commons: Annotated[dict, Depends(get_interest)]):
    """
    Return a specific interest
    :return: an Interest object
    """
    return commons


@router.post('/', response_model=Interest)
def post_interest(commons: Annotated[dict, Depends(post_interest)]):
    """
    [endpoint to be deleted in production]
    Create a new Interest
    :return: an Interest object
    """
    return commons
