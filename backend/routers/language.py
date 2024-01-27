from typing import Annotated
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status
from backend.services.language import get_languages
from backend.models.language import Language

router = APIRouter(prefix='/languages', tags=['languages'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get("/", response_model=Page[Language])
async def get_languages(commons: Annotated[Page[Language], Depends(get_languages)]):
    """
    Return a paginated list of languages
    :return: a paginated list of languages
    """
    return commons
