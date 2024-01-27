from datetime import timedelta, datetime, timezone
from typing import Annotated
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from pydantic import BaseModel
from sqlmodel import Session, select
from backend.exceptions.credentials_exception import CredentialsException
from backend.models.user import User
from backend.repository.repository import create_session
from backend.responses.user_response import UserResponse

SECRET_KEY = "2c0fb37921906f1614f8f5905af837942b4672aa82943ac5058591a130a2a4aa"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 60
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="users/login")


class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse


def create_access_token(data: dict, expiration_minutes=ACCESS_TOKEN_EXPIRE_MINUTES):
    """
    Create a jwt token for a given set of data
    :param data: data representing an authorized entity
    :param expiration_minutes: life period of the token
    :return: jwt token
    """
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=expiration_minutes)

    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], db: Annotated[Session, Depends(create_session)]):
    """
    return the authorized entity data based on their token
    :param db: injected database
    :param token: jwt token
    :return: authorized entity data (user)
    """
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise CredentialsException("Corrupted access token")

    except JWTError as e:
        raise CredentialsException(f"Corrupted access token: {e}")

    user = db.exec(select(User).where(User.email == username)).first()
    if user is None:
        raise CredentialsException("Corrupted access token")

    return user
