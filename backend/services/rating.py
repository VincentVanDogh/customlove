from typing import Annotated
from fastapi import Depends, HTTPException
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import Session, select
from starlette.requests import Request
from backend.models.rating import Rating
from backend.repository.repository import create_session
from backend.utils.pagination import PaginationParams


def get_ratings(db: Annotated[Session, Depends(create_session)], request: Request):
    """
    Return a list of all ratings
    :param request: injected request
    :param db: injected database
    :return: a list of all ratings
    """
    return paginate(db, select(Rating), PaginationParams(size=request.query_params.get("size"),
                                                         page=request.query_params.get("page")))


def get_rating(rating_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return a specific rating
    :param rating_id: the id of the rating
    :param db: injected database
    :return: a rating object
    """
    rating = db.exec(select(Rating).where(Rating.id == rating_id)).first()
    if rating is None:
        raise HTTPException(status_code=404, detail=f"Could not find rating with id = {rating_id}")

    return rating


def post_rating(rating: Rating, db: Annotated[Session, Depends(create_session)]):
    """
    Create a rating object
    :param rating: the rating object
    :param db: injected database
    :return: a rating object
    """
    db.add(rating)
    db.commit()
    db.refresh(rating)
    return rating
