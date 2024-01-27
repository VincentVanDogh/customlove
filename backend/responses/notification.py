import json
from typing import Any

from pydantic import BaseModel
from enum import Enum

from sqlmodel import SQLModel

from backend.models.message import message_factory


class NotificationType(str, Enum):
    message: str = "message"
    match: str = "match"
    refresh: str = "refresh"


class Notification(BaseModel):
    type: NotificationType
    content: Any

    def __init__(self, _json: json):
        super().__init__(type=NotificationType[_json["type"]], content=_json["content"])

    @classmethod
    def factory(cls, content: Any):
        return Notification(
            {"type": NotificationType.message, "content": content}
        )
