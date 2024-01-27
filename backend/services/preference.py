from typing import Annotated
from fastapi import Depends, HTTPException
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import Session, select
from starlette.requests import Request
from backend.models.preference import Preference
from backend.repository.repository import create_session
from backend.utils.pagination import PaginationParams


def get_preferences(db: Annotated[Session, Depends(create_session)], request: Request):
    """
    Return a list of all preferences
    :param db: injected database
    :return: a list of preferences
    """
    return paginate(db, select(Preference), PaginationParams(size=request.query_params.get("size"),
                                                             page=request.query_params.get("page")))


def get_preference(preference_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return a preference
    :param preference_id: the id of the preference
    :param db: injected database
    :return: a preference object
    """
    preference = db.exec(select(Preference).where(Preference.id == preference_id)).first()
    if preference is None:
        raise HTTPException(status_code=404, detail=f"Could not find preference with id = {preference_id}")

    return preference


def post_preference(preference: Preference, db: Annotated[Session, Depends(create_session)]):
    """
    Create a preference
    :param preference: the preference object
    :param db: injected database
    :return: a preference object
    """
    db.add(preference)
    db.commit()
    db.refresh(preference)
    return preference
