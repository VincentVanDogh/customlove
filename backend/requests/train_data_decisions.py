from pydantic import BaseModel
from typing import List


class DecisionsRequest(BaseModel):
    decisions: List[int]