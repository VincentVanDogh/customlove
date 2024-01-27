from fastapi import HTTPException
from starlette import status


class FatalException(HTTPException):
    """
    Exception used to signal unexpected and unrecoverable errors.
    """
    def __init__(self, message):
        super(FatalException, self).__init__(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=message)
