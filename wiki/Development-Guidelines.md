<h1 align="center">Development Guidelines 📖</h1>

## Language

The commentaries, commits and other forms of documentation related to the project are to be typed in English.

## Code conventions

The code conventions used are those of the respective programming language, as we will be implementing this project with
Django, we follow the guidelines specified in [PEP 8 – Style Guide for Python Code](https://peps.python.org/pep-0008/).

### Python conventions
As Python leaves a lot open for the user to decide unlike other programming languages, one of the concerns mentioned when picking Python was the risk of quickly writing spaghetti-code. To avoid this, team members are expected to follow the principles object-oriented programming. In addition it would be advantageous if each variable is also accompanied by a data type, as these can be omitted, but in doing so can quickly lead to confusion once the project becomes increasingly larger and more complex.

## Commit conventions

Create Branches with the same name as made by GitLab under "Issues" in square brackets, followed by a short summary. In the next two lines, elaborate what was implemented.

```
[issue-<issue_nr>] short summary

what was implemented
```

### Example

As shown in picture below, the branch name is "2-weekly-meeting". A commit message would look in the following manner:

```
[2-weekly-meeting] Example for a commit.

Providing the users with a detailed description of how a commit should be formulated.
```

![commit-name](uploads/f02a98c70ee70ae5a13d11ff2ae4928e/commit-name.png)

## Time-tracking

After each meeting or any work related to the project, the team member is expected to push the time invested into the
project to the respective issue.
* Time is preferably documented in 15 minute intervals.

## Backend conventions
Please find a short description on how to further develop our backend app with coherence to the already existing code.

### Request flow
Every request is handled by our application following FastApi recommended patterns:
1. The request is handled by the appropriate router based on its path (`backend/routers`).
2. The request is passed to the appropriate service, which is provided to the router by dependency injection.
3. The service handles the request usign the connection to the database which is provided by dependency injection. (it is planned to introduce a new layer of abstraction between the services and the db with `repository` objects - https://reset.inso.tuwien.ac.at/repo/2023ws-ase-pr-group/23ws-ase-pr-inso-06/-/issues/30).

### JWT tokens
1. All endpoints (at the final stage of development) should be protected by the jwt mechanism (except for users/login).
2. The user data from the jwt token is extracted automatically through dependency injection and is provided as a `user` object to the services.

### Pagination
1. All endpoints that return a collection of elements should return paginated responses.
2. A pagination mechanism from fastapi.pagination is used in our implementation (see `backend/utils/pagination.py`)
3. The important thing to note is that the imports have to be correct!
  in the services (the paginate method must be from `fastapi_pagination.ext.sqlmodel` **not** `fastapi_pagination` or `fastapi_pagination.ext.async_sqlmodel`):
  ```python
  from fastapi_pagination.ext.sqlmodel import paginate
  ```
  in the routers (the page object has to be imported from `backend.utils.pagination`):
  ```python
  from backend.utils.pagination import Page
  ```

Example of an endpoint router and service function:
```python
@router.get("/", response_model=Page[Conversation])
def get_conversations(commons: Annotated[Page[Conversation], Depends(get_conversations)]):
    return commons


def get_conversations(user: Annotated[User, Depends(get_current_user)],
                      db: Annotated[Session, Depends(create_session)], request: Request):
    return paginate(db, select(Conversation).where(or_(Conversation.user1_id == user.id,
                                                       Conversation.user2_id == user.id)),
                    PaginationParams(size=request.query_params.get("size"), page=request.query_params.get("page")))
```

### Testing
1. This project uses the `pytest` library to perform integration testing.
2. Please find all the necessary functions in the `test_utils.py`. Especially important is how we handle jwt creation in tests:
    ```python
    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/conversations") # get request
    response = authorized_request(token, client, lambda c: c.post, "/conversations") # post request
    response = authorized_request(token, client, lambda c: c.post, "/conversations", json={}) # post request with a body
    ```
Please create requests protected by jwts using the `authorized_request` function. You can test any function supported by the client object and provide any `**kwargs` (like `json={...}`)