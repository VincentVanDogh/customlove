from fastapi import HTTPException
from starlette import status


class BadRequestException(HTTPException):
    """
    Exception used to signal unexpected and unrecoverable errors.
    """
    def __init__(self, message=""):
        super(BadRequestException, self).__init__(status_code=status.HTTP_400_BAD_REQUEST, detail=message)
