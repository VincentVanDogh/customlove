from fastapi import HTTPException
from starlette import status


class ValidationException(HTTPException):
    """
    Exception that signals, that data, that came from outside the backend, is invalid.
    The data violates some invariant constraint (rather than one, that is imposed by the current data in the system).
    Contains a list of all validations that failed when validating the piece of data in question.
    """
    def __init__(self, message=""):
        super(ValidationException, self).__init__(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=message)
