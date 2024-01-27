from fastapi import HTTPException
from starlette import status


class CredentialsException(HTTPException):
    """
    Exception used to signal unexpected and unrecoverable errors.
    """

    def __init__(self, message=""):
        super(CredentialsException, self).__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=message,
            headers={"WWW-Authenticate": "Bearer"},
        )
