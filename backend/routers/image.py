from typing import Annotated, List, Dict

from fastapi import APIRouter, Depends
from fastapi.openapi.models import Response
from starlette import status

from backend.models.message import Message
from backend.services.image import post_image, get_image

router = APIRouter(prefix='/images', tags=['images'], responses={
    status.HTTP_200_OK: {"description": "Success"}
})


@router.get(path="/{image_id}")
def get_image(commons: Annotated[Response, Depends(get_image)]):
    return commons


@router.post(path="", response_model=Message)
def post_image(commons: Annotated[Message, Depends(post_image)]):
    return commons
