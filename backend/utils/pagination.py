from fastapi import Query
from fastapi_pagination import Page
from fastapi_pagination import Params

DEFAULT_SIZE = 50
MIN_SIZE = 1
MAX_SIZE = 100

DEFAULT_PAGE = 1
MIN_PAGE = 1

Page = Page.with_custom_options(
    size=Query(default=DEFAULT_SIZE, ge=MIN_SIZE, le=MAX_SIZE),
    page=Query(default=DEFAULT_PAGE, ge=MIN_PAGE, description="Page number"),
)


class PaginationParams(Params):
    def __init__(self, page=DEFAULT_PAGE, size=DEFAULT_SIZE):
        page = DEFAULT_PAGE if page is None else page
        size = DEFAULT_SIZE if size is None else size

        super().__init__(page=page, size=size)
