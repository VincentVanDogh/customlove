from typing import List, Annotated
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status
from backend.models.gender_identity import GenderIdentity
from backend.responses.error_response import ErrorResponse
from backend.services.gender_identity import get_gender_identity, get_gender_identities, post_gender_identity

router = APIRouter(prefix='/gender-identities', tags=['gender-identities'], responses={
    status.HTTP_200_OK: {"description": "Success"}
})


@router.get("/", response_model=Page[GenderIdentity])
async def get_gender_identities(commons: Annotated[Page[GenderIdentity], Depends(get_gender_identities)]):
    """
    Get all Gender Identities in the db
    :return: paginated list of gender identities
    """
    return commons


@router.get('/{gender_identity_id}', response_model=GenderIdentity, responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
})
def get_gender_identity(commons: Annotated[dict, Depends(get_gender_identity)]):
    """
    Get the desired gender identity
    :return: a GenderIdentity object
    """
    return commons


@router.post('/', response_model=GenderIdentity)
def post_gender_identity(commons: Annotated[dict, Depends(post_gender_identity)]):
    """
    [endpoint to be deleted in production]
    Add a new GenderIdentity
    :return: a GenderIdentity object
    """
    return commons
