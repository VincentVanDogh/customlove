from typing import List, Annotated
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status

from backend.responses.error_response import ErrorResponse
from backend.services.swipe_status import post_view, post_like, get_matches
from backend.models.swipe_status import SwipeStatus

router = APIRouter(prefix='/swipe_statuses', tags=['swipe_statuses'], responses={
    status.HTTP_200_OK: {"description": "Success"}
})


@router.get("/matches", response_model=Page[SwipeStatus], responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
async def get_matches(commons: Annotated[Page[SwipeStatus], Depends(get_matches)]):
    return commons


@router.post('/view/{user_id}', response_model=SwipeStatus, responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
async def post_swipe_status_view(commons: Annotated[dict, Depends(post_view)]):
    return commons


@router.post('/like/{user_id}', response_model=SwipeStatus, responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
async def post_like_status_like(commons: Annotated[dict, Depends(post_like)]):
    return commons
