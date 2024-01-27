from typing import Annotated
from fastapi import Depends, HTTPException
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import Session, select
from starlette.requests import Request
from backend.models.gender_identity import GenderIdentity
from backend.repository.repository import create_session
from backend.utils.pagination import PaginationParams


def get_gender_identities(db: Annotated[Session, Depends(create_session)], request: Request):
    """
    Return all gender identities
    :param request: injected request
    :param db: injected database
    :return: a paginated list of gender identities
    """
    return paginate(db, select(GenderIdentity), PaginationParams(size=request.query_params.get("size"),
                                                       page=request.query_params.get("page")))


def get_gender_identity(gender_identity_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return a certain gender identity
    :param gender_identity_id: id of the searched entity
    :param db: injected database
    :return: a GenderIdentity object
    """
    gender_identity = db.exec(select(GenderIdentity).where(GenderIdentity.id == gender_identity_id)).first()
    if gender_identity is None:
        raise HTTPException(status_code=404, detail=f"Could not find gender_identity with id = {gender_identity_id}")

    return gender_identity


def post_gender_identity(gender_identity: GenderIdentity, db: Annotated[Session, Depends(create_session)]):
    """
    Create a new gender identity
    :param gender_identity: a GenderIdentity object
    :param db: injected database
    :return: a GenderIdentity object
    """
    db.add(gender_identity)
    db.commit()
    db.refresh(gender_identity)
    return gender_identity
