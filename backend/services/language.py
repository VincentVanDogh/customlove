from typing import Annotated
from fastapi import Depends
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import Session, select
from starlette.requests import Request
from backend.models.language import Language
from backend.repository.repository import create_session
from backend.utils.pagination import PaginationParams


def get_languages(db: Annotated[Session, Depends(create_session)], request: Request):
    """
    Return a list of all languages
    :return: a list of all languages
    """
    return paginate(db, select(Language), PaginationParams(size=request.query_params.get("size"),
                                                 page=request.query_params.get("page")))
