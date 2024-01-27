from typing import Annotated
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status
from backend.models.rating import Rating
from backend.responses.error_response import ErrorResponse
from backend.services.rating import get_rating, get_ratings, post_rating

router = APIRouter(prefix='/ratings', tags=['ratings'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get("/", response_model=Page[Rating])
async def get_ratings(commons: Annotated[Page[Rating], Depends(get_ratings)]):
    """
    Return a paginated list of ratings
    :param commons:
    :return:
    """
    return commons


@router.get('/{rating_id}', response_model=Rating, responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
})
def get_rating(commons: Annotated[dict, Depends(get_rating)]):
    """
    Return a specific rating
    :return: a rating object
    """
    return commons


@router.post('/', response_model=Rating)
def post_rating(commons: Annotated[dict, Depends(post_rating)]):
    """
    Create a rating
    :return: a rating object
    """
    return commons
