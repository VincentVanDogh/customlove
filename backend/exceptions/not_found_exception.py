from fastapi import HTTPException
from pydantic import BaseModel
from starlette import status


class NotFoundException(HTTPException):
    """
    Exception used to signal that a certain object could not be found within the database.
    """
    def __init__(self, message=""):
        super(NotFoundException, self).__init__(status_code=status.HTTP_404_NOT_FOUND, detail=message)
