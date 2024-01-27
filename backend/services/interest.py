from typing import Annotated
from fastapi import Depends, HTTPException
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import Session, select
from starlette.requests import Request
from backend.models.interest import Interest
from backend.repository.repository import create_session
from backend.utils.pagination import PaginationParams


def get_interests(db: Annotated[Session, Depends(create_session)], request: Request):
    """
    Return all interests
    :param request: injected request
    :param db: injected database
    :return: a list of interests
    """
    return paginate(db, select(Interest), PaginationParams(size=request.query_params.get("size"),
                                                 page=request.query_params.get("page")))


def get_interest(interest_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return a specific Interest
    :param interest_id: the id of the Interest
    :param db: injected database
    :return: an Interest object
    """
    interest = db.exec(select(Interest).where(Interest.id == interest_id)).first()
    if interest is None:
        raise HTTPException(status_code=404, detail=f"Could not find interest with id = {interest_id}")

    return interest


def post_interest(interest: Interest, db: Annotated[Session, Depends(create_session)]):
    """
    [endpoint to be deleted in production]
    Create an Interest
    :param interest: an interest object
    :param db: injected database
    :return: an interest object
    """
    db.add(interest)
    db.commit()
    db.refresh(interest)
    return interest
