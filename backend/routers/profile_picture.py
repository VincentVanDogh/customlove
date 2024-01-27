from typing import Annotated, List, Dict, Any

from fastapi import APIRouter, Depends
from fastapi.openapi.models import Response
from starlette import status

from backend.models.message import Message
from backend.services.profile_picture import get_profile_picture, \
    post_profile_picture, put_profile_picture

router = APIRouter(prefix='/profile-picture', tags=['images'], responses={
    status.HTTP_200_OK: {"description": "Success"}
})


@router.get(path="/{user_id}")
def get_profile_picture(commons: Annotated[Any, Depends(get_profile_picture)]):
    return commons


@router.post(path="")
def post_profile_picture(commons: Annotated[Dict, Depends(post_profile_picture)]):
    return commons


@router.put(path="")
def put_profile_picture(commons: Annotated[Dict, Depends(put_profile_picture)]):
    return commons
